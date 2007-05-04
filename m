Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXEDOJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXEDOJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXEDOJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:09:25 -0400
Received: from ozlabs.org ([203.10.76.45]:45794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbXEDOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:09:24 -0400
Subject: [RELEASE] linux-2.6.21 backport: 269 version
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:09:05 +1000
Message-Id: <1178287745.23670.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to everyone who sent bug reports.  I've backported all the fixes
and tweaks.

Changes since last 2.6.21 release (254):

1) Method for building launcher with out-of-tree build (patch from Tony Breeds)
2) SIOCBRADDIF definition for older libc headers (report by Wang Cong)
3) Warning suppression for put_user/get_user (Wang Cong report again)
4) Numerous typo fixes (Jeremy Fitzhardinge's eyes)
5) Rework of networking documentation (Glauber de Oliveira Costa's whining)
6) Block documentation includes new love scene.

Heroic hacking!
Rusty Russell <rusty@rustcorp.com.au>


