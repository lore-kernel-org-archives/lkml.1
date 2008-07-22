Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYGVMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYGVMl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYGVMlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:41:50 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:61898 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYGVMlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:41:50 -0400
Date: Tue, 22 Jul 2008 08:41:27 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Floppy access by dd fails for 2.6.26-rc2 to final,
 possibly even earlier
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200807220841.27796.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just been advised by private email that I an not the only one who has lost the 
use of his floppy drive via dd.  The corresponder noted that he had a copy of 
DSL with a 2.4.something kernel, and his drive worked flawlessly while booted 
to DSL.

So now there are at least 2 floppy users wandering in the wilderness looking for 
water.  We need it to support 20 year old computers without a TCP stack or 
network cards.

Who is the floppy.c maintainer these days?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
For fools rush in where angels fear to tread.
		-- Alexander Pope
