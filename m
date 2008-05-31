Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYEaIS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYEaIS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEaISP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:18:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYEaISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:18:13 -0400
Date: Sat, 31 May 2008 04:18:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] vfs: dcache cleanups
Message-ID: <20080531081812.GB24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113307.432012922@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113307.432012922@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, although mixing up the sparse warning fixes and the d_path
cleanup in one patch is a little odd.

