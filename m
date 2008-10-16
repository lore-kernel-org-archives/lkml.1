Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYJPWo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYJPWo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYJPWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:44:16 -0400
Received: from kroah.org ([198.145.64.141]:57944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754939AbYJPWoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:44:15 -0400
Date: Thu, 16 Oct 2008 15:39:06 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [stable] [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016223906.GA18144@kroah.com>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016173529.GA13038@kroah.com> <20081016181044.GA16092@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016181044.GA16092@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 02:10:44PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 16, 2008 at 10:35:29AM -0700, Greg KH wrote:
> > Is this patch already in Linus's tree?  If so, do you have a git commit
> 
> 6c5e51dae2c37127e00be392f40842e08077e96a

Thanks, now queued up.

greg k-h
