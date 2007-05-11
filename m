Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbXEKIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbXEKIf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXEKIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:35:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:14982 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXEKIfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zm0Aa8XoReMjG3pOOWiYUO50JGuJ0aGzf/L7zHWkTzkTuxZFl5xh4etsAcad5eGGPp1Q/28fPtFUOyFeMukCwMf0Y7UD9CG6k+bnktKq0K+dEKYfLGvYFn5E6xJJWOUtQSq5wpHE1a2d6rC4UIpteFjKFNhvv+dPgcaryyUp/NE=
Message-ID: <9a8748490705110135k14599ac1n46b33817df8ffbcc@mail.gmail.com>
Date: Fri, 11 May 2007 10:35:18 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "devzero@web.de" <devzero@web.de>
Subject: Re: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com
In-Reply-To: <1783741195@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1783741195@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/07, devzero@web.de <devzero@web.de> wrote:
> Hi !
>
> I like lxr pretty much.
> i`m not a programmer, but i often need some information on "what`s the driver version of xyz in latest kernel" or "was this or that feature/patch already being merged" or "i have this line of code in kernel - how does it look in recent kernel , did it change " ?
>

Some of this is often easier to find through git.
See http://linux.yyz.us/git-howto.html and
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=summary


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
