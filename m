Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXDHJqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXDHJqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 05:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXDHJqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 05:46:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35258 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXDHJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 05:46:10 -0400
Date: Sun, 8 Apr 2007 10:46:06 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] partitions: Touch up comments for check.h and ibm.h
Message-ID: <20070408094606.GA29802@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"John Anthony Kazos Jr." <jakj@j-a-k-j.com>, aeb@cwi.nl,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com> <alpine.DEB.0.83.0704072338060.27057@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704072338060.27057@sigma.j-a-k-j.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 11:38:46PM -0400, John Anthony Kazos Jr. wrote:
> +/*
> + *  fs/partitions/check.h
> + */

this one is utterly useless and actually harmful because it can easily
get out of sync.

> @@ -1 +1,5 @@
> +/*
> + *  fs/partitions/ibm.h
> + */

ditto
