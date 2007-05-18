Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbXEROTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbXEROTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXEROTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:19:42 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:56519 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbXEROTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:19:41 -0400
Subject: Re: [oops] in bluetooth
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070518141342.GA3692@elf.ucw.cz>
References: <20070518141342.GA3692@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 18 May 2007 16:19:48 +0200
Message-Id: <1179497988.10069.198.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> I played with rfcomm here -- I'm trying to emulate bluetooth gps using
> normal pc -- and got couple of oopses.
> 
> pavel@amd:~$ uname -a
> Linux amd 2.6.21 #421 SMP Fri Apr 27 15:06:54 CEST 2007 i686 GNU/Linux
> pavel@amd:~$
> 

can you try with 2.6.22-rc1. I have seen this before, but never actually
found the root cause for it. It might be inside the sysfs layer.

Regards

Marcel


