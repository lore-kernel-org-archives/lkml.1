Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYHPEQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYHPEQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbYHPEGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:23 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33314 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYHPEFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:46 -0400
Date: Fri, 15 Aug 2008 21:41:48 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3fmOc022579@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] mdb: UPDATED version 2.6.27-rc3 released
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08-15-2008
Changelog:


Patch 1/1
remove module base conditionals.  remove any reference to any file
owned or maintained by Ingo Molnar based on his statement he has
no interest in being involved in decisions involving debuggers.

Fixed UP problems with generic genapic settings.

I will be maintaining this debugger and posting releases for EACH AND
EVERY Linux kernel version posted to the public, including EACH AND
EVERY release candidate.  

Any of these releases at any time may be adopted into the Linux Kernel,
modified, copied, distributed, bastardized, and whatever else someone
wants to do with it.  You can even use it for the purpose intended and I
hope it helps you find bugs easier and make better progress if you 
are ever trapped in a remote data center wilderness closet far from 
a computer hospital and you do not have access to two computers and 
a NULL modem cable to use KGDB, or KDB keeps locking up with the wierd
flashing keyboard thingee, and the stack backtrace that runs off the end
of the miniscule 4K stack in the standard kernel.

Updated patch with fixes and removal of code sections by request:

http://www.wolfmountaingroup.org

http://www.omega8.org

ftp://www.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc3-ia32-08-15-08.patch


Jeff


This debugger development is supported by http://www.intel.com Intel and http://www.Omega8.com.  

I want to thank Intel for providing 64 bit systems for debugger and Forensic Filesystem Development and other support of these projects.




