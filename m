Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZJKW3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZJKW3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZJKW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:29:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45391 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752949AbZJKW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:29:46 -0400
Date: Sun, 11 Oct 2009 23:30:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Nick Bowler" <nbowler@elliptictech.com>
Subject: Re: [Bug #14382] Transmit failure in et131x.
Message-ID: <20091011233002.0ebd2608@lxorguk.ukuu.org.uk>
In-Reply-To: <r-4Wjt4coy.A.KaC.Qal0KB@chimera>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	<r-4Wjt4coy.A.KaC.Qal0KB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 00:22:05 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).

Patch sent for testing, nothing heard back. I think I've fixed it - I
certainly found a bug 8)
