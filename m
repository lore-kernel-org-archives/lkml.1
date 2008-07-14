Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYGNCvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYGNCvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYGNCux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:50:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:1297 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYGNCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Eqoev6So2jc1fZbcXlTjLGvGIosIW53vwzKS+5ng41+KJ7kKkVGBFoPNlq2iOfMO1j
         G/SrQdDDgnD7g9PoK3X/sQfJ+ecWbKraVjlOvB4iw5jM4uJ7FoyLc8YgUkuSoYKauQ0e
         ouAZFkEu5ORqv6ob5n6Az6sFr6z6FC6kCU5o8=
Message-ID: <df9815e70807131950u64f75d67n28484ea8ddddb212@mail.gmail.com>
Date: Mon, 14 Jul 2008 10:50:49 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20080610190540.GA25066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610190540.GA25066@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Is there a separate mailing-list for staging?

-- 
Thanks and Regards,
Jike

On Wed, Jun 11, 2008 at 3:05 AM, Greg KH <greg@kroah.com> wrote:
> Oh great, not yet-another-kernel-tree, just what the world needs...
>
> Yes, this is an announcement of a new kernel tree, linux-staging.  It is
> a quilt series of patches that can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
