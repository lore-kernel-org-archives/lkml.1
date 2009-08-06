Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZHFD4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZHFD4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZHFD4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:56:36 -0400
Received: from kroah.org ([198.145.64.141]:57929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZHFD4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:56:35 -0400
Date: Wed, 5 Aug 2009 20:51:51 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/7] scripts/get_maintainer.pl: Add sections in pattern
 match depth order
Message-ID: <20090806035151.GD24631@kroah.com>
References: <cover.1249525834.git.joe@perches.com>
 <0b6f4e55641868094dd770f5e2bdbf093c473b26.1249525834.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b6f4e55641868094dd770f5e2bdbf093c473b26.1249525834.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 07:43:43PM -0700, Joe Perches wrote:
> Before this change, matched sections were added in the order
> of appearance in the normally alphabetic section order of
> the MAINTAINERS file.

Ah, very nice, great change, I like it.

thanks,

greg k-h
