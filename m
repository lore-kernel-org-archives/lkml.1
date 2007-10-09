Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbXJISHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbXJISHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXJISHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:38006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:03 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 00/10] Use struct path in struct nameidata
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin for inclusion into -mm of the patch series I send on 27th
September. I haven't changed the patches except for letting them apply on
2.6.23-rc8-mm1.

Andrew, please add this to -mm.

Thanks,
Jan

-- 

