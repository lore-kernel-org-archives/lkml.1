Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbYFWTbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbYFWTbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbYFWTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:31:39 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46117 "EHLO
	ns1.utah-nac.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761266AbYFWTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:31:38 -0400
Message-ID: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 23 Jun 2008 13:22:26 -0600 (MDT)
Subject: Forensic File System GUID Linux/Windows
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


The following GUID is being used in the Wolf Mountain Group, Inc. Forensic
File System (FFS) for GPT intel EFI partitions.  Since there is no central
registry for EFI GUID's it is posted here for referece for folks who may
run accross it on Windows Vista, 2003, and 2008 systems running FFS on
Windows that may be using dual boot with Linux or vmware:

#define PARTITION_FFS_GUID \
    EFI_GUID( 0xBEEFCAFE, 0xFEED, 0x0000, \
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01)


Patches to efi.h and efi.c in /fs/partitions will be posted after July 2,
2008 to www.wolfmountaingroup.org.

Jeff



