Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYKVTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYKVTCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKVTCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:02:25 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:42225 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYKVTCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:02:24 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2008 14:02:24 EST
Message-ID: <51963.166.70.238.45.1227377156.squirrel@webmail.wolfmountaingroup.com>
Date: Sat, 22 Nov 2008 11:05:56 -0700 (MST)
Subject: Forensic File System Patches Posted 11-20-08
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pursuant to the GPL, the following patches are posted or the Forensic File
System appliance on Linux.  We will be shipping and are now shipping
support for Linux with the Forensic File System after reviewing customer
requirements and looking at GPL issues wit commercial software deployment.

ftp://ftp.wolfmountaingroup.org/pub/forenfs/ffs-2.6.26.4-el5-11-20-08.patch

The File System is not distributed with Linux or built on it or any other
GPL code and is not linked against Linux until installed by the customer
and is provided in a non-GNU object format for linking against Linux,
similar to how ndiswrapper works.  I do not believe there are any GPL
restrictions on customers downloading or purchasing Linux add ons provided
they are not distributing them with Linux.  I have observed that a large
number of companies, including the providers of VMWare and Novell
distribute Linux and GPL code with their proprietary software bundled with
it.

This appears to violate the GPL, but I am not certain of this.  So given
this, I am offering for sale Linux add ons not distributed with Linux and
providing the patches and kernel changes back as required by the GPL.

Jeffrey Vernon Merkey


I am working on MDB updates for 2.6.28 and will post mdb with major kernel
releases from now on in order to better measure kernel breakage between
releases.  The rc level debugger releases seem to be redundant since the
areas debuggers touch rarely changes.






