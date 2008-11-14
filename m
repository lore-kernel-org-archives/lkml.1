Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbYKNFQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbYKNFQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYKNFQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:16:15 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:26139 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYKNFQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:16:15 -0500
Message-ID: <491D0996.4080600@oracle.com>
Date: Thu, 13 Nov 2008 21:16:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jack@suse.cz
Subject: Re: mmotm 2008-11-13-17-22 uploaded (dquot build errors)
References: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
In-Reply-To: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.491D0999.0007:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmotm-2008-1113-1722/fs/dquot.c:1391: error: redefinition of '__kstrtab_dquot_reserve_space'
mmotm-2008-1113-1722/fs/dquot.c:1352: error: previous definition of '__kstrtab_dquot_reserve_space' was here
mmotm-2008-1113-1722/fs/dquot.c:1391: error: redefinition of '__ksymtab_dquot_reserve_space'
mmotm-2008-1113-1722/fs/dquot.c:1352: error: previous definition of '__ksymtab_dquot_reserve_space' was here
mmotm-2008-1113-1722/fs/dquot.c:2101: error: redefinition of '__kstrtab_vfs_dq_quota_on_remount'
mmotm-2008-1113-1722/fs/dquot.c:1974: error: previous definition of '__kstrtab_vfs_dq_quota_on_remount' was here
mmotm-2008-1113-1722/fs/dquot.c:2101: error: redefinition of '__ksymtab_vfs_dq_quota_on_remount'
mmotm-2008-1113-1722/fs/dquot.c:1974: error: previous definition of '__ksymtab_vfs_dq_quota_on_remount' was here

-- 
~Randy
