Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYFNVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYFNVr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYFNVrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:47:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51012 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755795AbYFNVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:47:41 -0400
Date: Sat, 14 Jun 2008 22:26:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Adam Williamson" <awilliamson@mandriva.com>,
       "Alan Cox" <alan@redhat.com>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents
 use of device
Message-ID: <20080614222621.084522fe@lxorguk.ukuu.org.uk>
In-Reply-To: <Jn7irxIunJK.A.hXD.3IDVIB@albercik>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.hXD.3IDVIB@albercik>
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

On Sat, 14 Jun 2008 22:12:04 +0200 (CEST)
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
> Date		: 2008-06-05 17:39 (10 days old)
> Handled-By	: Alan Cox <alan@redhat.com>

Still waiting for the actual attached result of the test patch to debug
this further. Guess it will miss 2.6.26
