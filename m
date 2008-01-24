Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYAZOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYAZOvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYAZOvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:51:45 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1054 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbYAZOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:51:44 -0500
X-Greylist: delayed 170935 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2008 09:51:44 EST
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Microblaze init port
Date: Thu, 24 Jan 2008 16:02:44 +0100
Message-Id: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

this is first set of patches with Microblaze Linux kernel port.
I tried to clean coding style and repair code with sparse. 

I tried to split patches to the smallest parts as were possible. 
Please be patient with incorrect division - it was a lot of patches.

I personally feel the biggest pain in header files. 

There are no comments in set of patches because I had no energy
write it. I suppose we will discuss more about individual patches.

I create pages for this longer process at www.monstr.eu - wiki page.
I will store all patches in my internal git tree till setup public
git server. And on my pages will be published tarballs.

Thanks to John Williams and Steve Neuendorffer for help
with clarification of individual patches.

Have a fun,
Michal Simek
www.monstr.eu
