Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbXIYPKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbXIYPKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXIYPJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:09:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:8469 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbXIYPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:09:54 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Tue, 25 Sep 2007 09:04:52 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Joerg Pommnitz" <pommnitz@yahoo.com>
cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Problems with 2.6.23-rc6 on AMD Geode LX800
Message-ID: <20070925150452.GA15162@cosmic.amd.com>
References: <267869.77756.qm@web51407.mail.re2.yahoo.com>
MIME-Version: 1.0
In-Reply-To: <267869.77756.qm@web51407.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 25 Sep 2007 15:04:45.0613 (UTC)
 FILETIME=[68BA6DD0:01C7FF85]
X-WSS-ID: 6AE7FC4213S245181-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/07 01:38 -0700, Joerg Pommnitz wrote:
> Chuck, Jordan,
> thanks for taking an interest in this problem. As suggested by Jordan I tried a new
> BIOS revision from
> http://www.digitallogic.ch/index.php?id=256&dir=/MSEP800%20-%20SM800PCX%20%20-%20MPC20%20-%20MPC21&mountpoint=23
> 
> Unfortunately the kernel still fails to boot in the same way.

You'll have to contact Digital Logic and have them check with the BIOS vendor
to see if the fix was made in that version or not.  I don't have that
particular board, so I can't try out the fixes here.

I'm still trying to track down the particulars of the fix from the BIOS 
vendor.  I'll let you know.

> Do you still need the disassembled reserve_bootmem_core? 

Sure - you might as well - just to make sure its the same problem.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


