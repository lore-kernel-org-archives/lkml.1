Return-Path: <linux-kernel-owner+w=401wt.eu-S940127AbXHIPaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940127AbXHIPaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbXHIP3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:29:43 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:58888 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbXHIP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:29:42 -0400
Message-Id: <20070809152744.519270818@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 17:27:44 +0200
From: miklos@szeredi.hu
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 0/4] VFS updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VFS tweaks needed for some FUSE features, but possibly useful to other
filesystems as well.

Comments are welcome.
-- 
