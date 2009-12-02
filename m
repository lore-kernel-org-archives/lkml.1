Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZLBPF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZLBPF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZLBPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:05:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41619 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbZLBPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:05:49 -0500
Message-Id: <20091202150454.616582634@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 02 Dec 2009 16:04:54 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] nfs: cleanups in nfs_rename()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

This small patchset cleans up accumulated cruft in nfs_rename().  It's
been lightly tested.

Thanks,
Miklos
--
