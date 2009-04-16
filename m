Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZDPPI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZDPPI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZDPPIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:08:47 -0400
Received: from verein.lst.de ([213.95.11.210]:36021 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZDPPIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:08:47 -0400
Date: Thu, 16 Apr 2009 17:07:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yoshinori Sato <ysato@users.sourceforge.jp>, takata@linux-m32r.org
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: last remaining asm/ header moves: h8300 and m32r
Message-ID: <20090416150707.GA941@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

h8300 and m32r are the last two architectures still having their asm/
headers in include/ instead of arch/$arch/include.  Any chance you could
do the move for 2.6.30 so we're only left with one way of doing it?
