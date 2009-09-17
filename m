Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZIQM6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZIQM6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZIQM6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:58:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZIQM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:58:11 -0400
Date: Thu, 17 Sep 2009 05:57:59 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster
Message-ID: <20090917125759.GA4045@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6oef08k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:23:39AM -0700, Eric W. Biederman wrote:
> 
> devtmpfs has numerous problems.  The once I see from a quick review.

<snip>

I'm confused, why did you not at least cc: Kay and I on this message, if
I was a paranoid person, I would think that you were somehow trying to
skirt around us for some unknown reason :(

I think Kay has raised the proper points already.

greg k-h
