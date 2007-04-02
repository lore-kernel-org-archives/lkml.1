Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXDBOaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXDBOaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXDBOaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:30:46 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:57468 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508AbXDBOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:30:45 -0400
Date: Mon, 02 Apr 2007 10:30:29 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: mmap error?
To: linux-kernel@vger.kernel.org, Andy Polyakov <appro@fy.chalmers.se>
Message-id: <200704021030.29747.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Has something been changed recently, say post 2.6.19, that would effect 
this error from k3b when I click start (the burn), with a fresh dvd+r in 
the drive:

--------
Using growisofs 7.0 Copyright (C) Andy Polyakov <appro@fy.chalmers.se>
Starting writing...
:-( unable to anonymously mmap 33554432; resource temporarily 
unavailable...
Fatal error at startup, resource temporarily unavailable...
--------

And k3b then ejects the tray.

Selinux is disabled.
Currently booted kernel 2.6.21-rc5

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Why be difficult when, with a bit of effort, you could be impossible?
