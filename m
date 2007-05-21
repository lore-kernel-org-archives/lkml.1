Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbXEULxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbXEULxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXEULxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:53:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbXEULxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:53:23 -0400
Date: Mon, 21 May 2007 12:53:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch 1/5] cio: Update documentation.
Message-ID: <20070521115322.GB15143@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Cornelia Huck <cornelia.huck@de.ibm.com>
References: <20070521105118.955425052@de.ibm.com> <20070521110108.214724333@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521110108.214724333@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 12:51:19PM +0200, Martin Schwidefsky wrote:
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> - read_dev_chars()/read_conf_data() are deprecated. Don't document them, but
>   advise to issue the channel program from the driver itself.

What's the reason these function aren't just removed?  They're just unused
bloat right now.

