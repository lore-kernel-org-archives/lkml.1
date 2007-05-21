Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXEUKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXEUKwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXEUKwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:52:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:36971 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXEUKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=faG9qGX5lj4qLArtUfCr9W+yjuXYjRbLQYVlvmmfG1vF0FQ7kMpcTyUKc84P7mAdwmgxIPYu691I3ySBzsbo3p5VB2b/OqT9Je2GOGVgNxxMjCI9KKL7XvVFpOUYVrMXN+Zy4VQjSRcT51T52X3NYQ2ukAOufL7YsuZ0IL6WWG0=
Message-ID: <84144f020705210352k709c9480ueddf9d2569bb5d0@mail.gmail.com>
Date: Mon, 21 May 2007 13:52:16 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Remove the deprecated "kmem_cache_t" typedef from slab.h.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, clameter@sgi.com
In-Reply-To: <Pine.LNX.4.64.0705210604030.17699@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705210604030.17699@localhost.localdomain>
X-Google-Sender-Auth: e2860f3ed48f44e6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> Given that there is no remaining usage of the deprecated kmem_cache_t
> typedef anywhere in the tree, remove that typedef.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
