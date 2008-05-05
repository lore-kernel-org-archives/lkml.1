Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYEEC3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYEEC3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYEEC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:29:23 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:49601 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYEEC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:29:21 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: [PATCH 38/56] microblaze_v2: atomic.h bitops.h byteorder.h
From: John Williams <john.williams@petalogix.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <200805042358.15131.arnd@arndb.de>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
	 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
	 <200805042358.15131.arnd@arndb.de>
Content-Type: text/plain
Organization: PetaLogix
Date: Mon, 05 May 2008 12:28:39 +1000
Message-Id: <1209954519.5798.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-04 at 23:58 +0200, Arnd Bergmann wrote:
> On Sunday 04 May 2008, monstr@seznam.cz wrote:
> >  include/asm-microblaze/atomic.h    |  108 ++++++++++++++++++++++++++++++++++++
> 
> It would be cool if you could introduce this file as 
> asm-generic/atomic-irqdisable.h or similar (can someone please
> think of a better name?).

atomic-nonnative.h?

atomic-emulated.h?

atomic-wish-we-had-it-native.h?



