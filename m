Return-Path: <linux-kernel-owner+w=401wt.eu-S1031128AbXDQRBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031128AbXDQRBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031203AbXDQRB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:01:29 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2550 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031128AbXDQRB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:01:29 -0400
X-AuthUser: hirofumi@parknet.jp
To: Trond.Myklebust@netapp.com
Cc: linux-kernel@vger.kernel.org
Subject: nfs: desynchronized value of nfs_i.ncommit.
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 18 Apr 2007 02:01:21 +0900
Message-ID: <87hcrfaqam.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got the following message today. Probably, it happened on heavy load.

NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
NFS: desynchronized value of nfs_i.ncommit.
[...]

Any idea? Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
