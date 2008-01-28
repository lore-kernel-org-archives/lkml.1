Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbYA1WQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbYA1WQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbYA1WLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:11:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46475 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761248AbYA1WLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:11:05 -0500
Date: Tue, 29 Jan 2008 00:11:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Igor Mammedov <niallain@gmail.com>, Steve French <sfrench@us.ibm.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: struct cifs_dfs_referral_inode_operations is unused
Message-ID: <20080128221131.GY8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cifs_dfs_referral_inode_operations is unused, which does not seem 
to have been intended?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

