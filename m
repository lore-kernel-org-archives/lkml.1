Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZCITTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZCITTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZCITSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:18:49 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1592 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZCITSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:18:48 -0400
Subject: Re: [rtc-linux] Re: [PATCH 7/7] powerpc/ps3: Add rtc-ps3
From: Joe Perches <joe@perches.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Geert.Uytterhoeven@sonycom.com,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <49B568D0.5000901@am.sony.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <20090309151216.17f13862@i1501.lan.towertech.it>
	 <49B55A21.2010801@am.sony.com>
	 <20090309194307.154f3e95@i1501.lan.towertech.it>
	 <49B568D0.5000901@am.sony.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:18:42 -0700
Message-Id: <1236626322.8307.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 12:06 -0700, Geoff Levand wrote:
> There was some work by Joe Perches to list the files a maintainer is
> responsible for into the MAINTAINERS file.  I think that would give
> you what you want, a way to automatically get the maintainer of a
> file.
> 
> Joe, could you let us know the status of that work?

I think it works fine, and is an acceptable
approach to finding a maintainer for either a
patch or a specific file.

The changes I've posted are probably not suitable
for merging by anyone other than Linus as
MAINTAINERS is the most heavily modified file
in the kernel tree.

I've submitted it several times after merging it
with the latest kernel without response from Linus.

I'd merge and submit it again if it could be accepted.

If someone would propose a mechanism that would
improve the possibility to get it merged, I'd
also appreciate that.

