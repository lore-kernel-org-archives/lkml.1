Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYGUO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYGUO5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYGUO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:57:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:3166 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYGUO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gMQJSMIokeNQ5awjeyYg2yHpvGApR+9QwJoo0UnkMRc1caYM9K/dlfrTrvWTR1K41u
         i5Q3OQw9YbMYGXz8G2VJLCUqbqzrj3PMwKsBgXiZGoZXxQ9u6NZldaJBZqjygyG6Jtkw
         wnTxfNiV6R5xfvVQGZrKQNLsMU17vmxToOt3Y=
Date: Mon, 21 Jul 2008 18:56:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup() and check failing allocation
Message-ID: <20080721145638.GD7694@lenovo>
References: <48845FAC.9070500@cn.fujitsu.com> <20080721101623.GB7694@lenovo> <20080721132429.GE28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721132429.GE28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Mon, Jul 21, 2008 at 02:24:29PM +0100]
[...]
| > So if you needed:
| > Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Applied.
| 

Thanks Al!

		- Cyrill -
