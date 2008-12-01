Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYLAQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYLAQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYLAQ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:57:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLAQ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:57:01 -0500
Date: Mon, 1 Dec 2008 11:57:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Harald Arnesen <skogtun.harald@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [ext4] Documentation patch
Message-ID: <20081201165700.GA26680@infradead.org>
References: <8763m3u9kv.fsf@basilikum.skogtun.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763m3u9kv.fsf@basilikum.skogtun.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 05:46:56PM +0100, Harald Arnesen wrote:
>      So when comparing with a metadata-only journalling filesystem, such
> -    as ext3, use `mount -o data=writeback'.  And you might as well use
> +    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use

data=ordered comes closest to what xfs does for quite a long time..

