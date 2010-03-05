Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0CEP0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:26:44 -0500
Received: from mx2.netapp.com ([216.240.18.37]:28021 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0CEP0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:26:42 -0500
X-IronPort-AV: E=Sophos;i="4.49,587,1262592000"; 
   d="scan'208";a="326685588"
Subject: Merge of the 'write_inode' branch from the VFS tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Fri, 05 Mar 2010 10:26:40 -0500
Message-ID: <1267802800.5174.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 05 Mar 2010 15:26:41.0327 (UTC) FILETIME=[416D73F0:01CABC78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

When you submitted the VFS changes for this merge window, I was hoping
you would include the 'write_inode' branch. I've been waiting for them
in order to push the NFS writeback improvements to Linus.

Would you be willing to either push the write_inode branch to Linus or
to Ack my doing so as part of the NFS push?

Cheers
  Trond
