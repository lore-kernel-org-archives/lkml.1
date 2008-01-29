Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYA2DqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYA2DqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYA2DqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:46:14 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60076 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYA2DqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:46:13 -0500
In-Reply-To: <20080128221131.GY8767@does.not.exist>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       Igor Mammedov <niallain@gmail.com>
MIME-Version: 1.0
Subject: Re: struct cifs_dfs_referral_inode_operations is unused
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF8FA32685.39B0AF43-ON872573DF.00149DC4-862573DF.0014C8F6@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Mon, 28 Jan 2008 21:46:10 -0600
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 01/28/2008 20:46:11,
	Serialize complete at 01/28/2008 20:46:11
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have one DFS patch remaining to merge and then will need to do a 
cleanup patch


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com



Adrian Bunk <bunk@kernel.org> 
01/28/2008 04:11 PM

To
Igor Mammedov <niallain@gmail.com>, Steven French/Austin/IBM@IBMUS
cc
linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject
struct cifs_dfs_referral_inode_operations is unused






struct cifs_dfs_referral_inode_operations is unused, which does not seem 
to have been intended?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed



