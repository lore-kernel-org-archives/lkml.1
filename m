Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbZDHUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbZDHUcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZDHUcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:32:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZDHUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:32:11 -0400
Date: Wed, 8 Apr 2009 16:32:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Separate out common fstatat code into vfs_fstatat
Message-ID: <20090408203209.GA14342@infradead.org>
References: <20090408160541.GA1812319@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408160541.GA1812319@fiona.linuxhacker.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 08:05:42PM +0400, Oleg Drokin wrote:
> This is a version incorporating Christoph's suggestion.
> 
> Separate out common *fstatat functionality into a single function
> instead of duplicating it all over the code.

Looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>
