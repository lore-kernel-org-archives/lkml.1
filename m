Return-Path: <linux-kernel-owner+w=401wt.eu-S1765743AbXFGP5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765743AbXFGP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbXFGP5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:57:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:59602 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXFGP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F35ZQIKiopB+zAxrbHyaJfdHCdy/rmBNhIjPSPD9x42uomLRJwmSZVUhkksnZAVgCdLMmK5BaVjlFKZ5pMgzQ66H2IsLLaBrjozEFFKnUNVjfahSql786vecdF6heC8o9U+S+yhxyt0uiS41OXPUfETUcevmwwVa9ZvhtRytIOw=
Message-ID: <7b69d1470706070857n761b1358sfa41887f9ff83ecf@mail.gmail.com>
Date: Thu, 7 Jun 2007 10:57:37 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH (trivial)] Fix typo in Documentation/keys.txt
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>, trivial@kernel.org
In-Reply-To: <a781481a0706070408qb5f13eexba0f7f80ef756cf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0706070408qb5f13eexba0f7f80ef756cf9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Fix a typo in Documentation/keys.txt.
>
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: David Howells <dhowells@redhat.com>
> Cc: trivial@kernel.org
>
> ---
>
>  Documentation/keys.txt |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> ---
>
> diff -ruNp a/Documentation/keys.txt b/Documentation/keys.txt
> --- a/Documentation/keys.txt    2007-06-03 02:33:02.000000000 +0530
> +++ b/Documentation/keys.txt    2007-06-03 02:38:52.000000000 +0530
> @@ -859,9 +859,8 @@ payload contents" for more information.
>         void unregister_key_type(struct key_type *type);
>
>
> -Under some circumstances, it may be desirable to desirable to deal with a
> -bundle of keys.  The facility provides access to the keyring type for managing
> -such a bundle:
> +Under some circumstances, it may be desirable to deal with a bundle of keys.
> +The facility provides access to the keyring type for managing such a bundle:
---

It would improve the latter sentence to either delete "access to" or
else change "provides access to" to "defines.

scott
