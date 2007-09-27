Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXI0OKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXI0OKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXI0OJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:46 -0400
Received: from ns.suse.de ([195.135.220.2]:36785 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbXI0OJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:44 -0400
Message-Id: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:00 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 00/10] Use struct path in struct nameidata
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of the patch series Andreas posted last month. It leaves out
the restructuring of the intent which will be done at a later point in time.

There are three preparing patches that remove unneeded code IMHO. I haven't
got feedback from Takashi since he is on holiday. Please, can somebody else
acknowledge the changes?

Comments?
Jan
-- 

