Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbXIHSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbXIHSzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXIHSzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:55:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52931 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbXIHSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:55:37 -0400
Date: Sat, 8 Sep 2007 11:54:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: 7eggert@gmx.de
Cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-Id: <20070908115434.afce4887.randy.dunlap@oracle.com>
In-Reply-To: <E1IU3Xv-0000d9-K0@be1.lrz>
References: <90ZEn-1YU-3@gated-at.bofh.it>
	<918Rh-7Or-5@gated-at.bofh.it>
	<919aD-8ua-7@gated-at.bofh.it>
	<E1IU3Xv-0000d9-K0@be1.lrz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007 18:52:35 +0200 Bodo Eggert wrote:

> BTW2: I think that menu needs very much reordering. "Block devices" should
> be renamed to "Other block devices", AGP support should belong into graphics
> support, and many other things I don't even know need to be pushed around.
> Even ordering by name would be better than the current situation! But it
> should be done by someone knowing these devices, I could only do a part.

how's this?

for 2.6.16-rc4:  consolidated graphics config:
http://marc.info/?l=linux-kernel&m=114101236918589&w=2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
