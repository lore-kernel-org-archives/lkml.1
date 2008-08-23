Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYHWXpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYHWXpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 19:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYHWXpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 19:45:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbYHWXpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 19:45:01 -0400
Date: Sat, 23 Aug 2008 19:44:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bug fixes
Message-ID: <20080823234439.GA24760@infradead.org>
References: <E1KWXf5-0004gv-P7@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KWXf5-0004gv-P7@closure.thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       ext4: Initialize writeback_index to 0 when allocating a new inode

Since commit 7d455e0030eeab820773e7786605be4d9e56a04b this is already
done in common code, so this changeset doesn't have any effect.

