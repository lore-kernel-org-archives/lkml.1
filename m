Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbZJITVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbZJITVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbZJITVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:21:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:50250 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761231AbZJITVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:21:04 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/1C6xy2lD1R2vdu5rV3OKhzD+OFnWlMSYyNGo/w/
	rnCBYYQpa0KT+l
Subject: ext4 corruptions
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Kernel Testers List <kernel-testers@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Oct 2009 21:20:13 +0200
Message-Id: <1255116014.3014.8.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have really bad ext4 corruptions, i needed to reinstall 3 of my test
systems.
The symptoms:
is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
bad things and will try to fix it. After this action is the system
unusable.

Do any one had same problem? The is no sans to bisect it, after some
jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
or fsck problem?

