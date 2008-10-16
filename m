Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYJPSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYJPSK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYJPSKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:10:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYJPSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:10:47 -0400
Date: Thu, 16 Oct 2008 14:10:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [stable] [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016181044.GA16092@infradead.org>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016173529.GA13038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016173529.GA13038@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:35:29AM -0700, Greg KH wrote:
> Is this patch already in Linus's tree?  If so, do you have a git commit

6c5e51dae2c37127e00be392f40842e08077e96a

