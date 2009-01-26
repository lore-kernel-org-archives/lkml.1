Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZAZMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZAZMDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZAZMDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:03:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56022 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbZAZMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:03:09 -0500
Date: Mon, 26 Jan 2009 12:02:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Larry Baker <baker@usgs.gov>
Cc: Discussion of Rocks Clusters <npaci-rocks-discussion@sdsc.edu>,
       Bill Davidsen <davidsen@tmr.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       greg.bruno@gmail.com, mason.katz@gmail.com
Subject: Re: [Rocks-Discuss] hdb: status error: error=0x40 <3>{
 UncorrectableError }
Message-ID: <20090126120232.516cd319@lxorguk.ukuu.org.uk>
In-Reply-To: <A2A0D2B1-F9AB-4CB2-AFB1-F341ADBAB959@usgs.gov>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
	<497CD30D.80203@tmr.com>
	<3f9a31f40901251310g38ecfe61t97e119533215d271@mail.gmail.com>
	<200901252249.17410.bzolnier@gmail.com>
	<3f9a31f40901252031l3bb0ec39nd077ff8f13df73bd@mail.gmail.com>
	<51ac1bba0901252130t408ab568k3b156e130f140a24@mail.gmail.com>
	<A2A0D2B1-F9AB-4CB2-AFB1-F341ADBAB959@usgs.gov>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 22:25:59 -0800
Larry Baker <baker@usgs.gov> wrote:

> Try a different, preferably new, cable.  Use an 80 conductor high- 
> speed cable if you can.  Also, check the pins to make sure none of  
> them are bent.

A bad cable would give you CRC errors, uncorrectable error is a drive
reporting a bad sector.
