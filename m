Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYFVUZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYFVUZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYFVUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:25:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57242 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbYFVUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:25:32 -0400
Date: Sun, 22 Jun 2008 21:07:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Adam Williamson" <awilliamson@mandriva.com>,
       "Alan Cox" <alan@redhat.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents
 use of device
Message-ID: <20080622210706.0a90c4ba@lxorguk.ukuu.org.uk>
In-Reply-To: <4mRZUF-hVeG.A.s6E.JupXIB@albercik>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	<4mRZUF-hVeG.A.s6E.JupXIB@albercik>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
> Subject		: Oops on loading ipaq module since 2.6.26, prevents use of device
> Submitter	: Adam Williamson <awilliamson@mandriva.com>
> Date		: 2008-06-05 17:39 (18 days old)
> Handled-By	: Alan Cox <alan@redhat.com>

Handed over to Greg as it's not a tty layer bug but something in USB
(actually from the traces I think its a broken gcc/build but we shall)
