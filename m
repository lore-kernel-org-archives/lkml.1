Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYIJL1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYIJL1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYIJL1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:27:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYIJL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:27:12 -0400
Date: Wed, 10 Sep 2008 07:27:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Message-ID: <20080910112709.GA11742@infradead.org>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h

And who cares?  

