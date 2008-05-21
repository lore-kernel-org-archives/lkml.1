Return-Path: <linux-kernel-owner+w=401wt.eu-S936020AbYEUTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936020AbYEUTBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYEUTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:01:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19754 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYEUTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=imRbQ8W4k6YbzgXvhgWQeuwKYgS3RPbTCXeEcCSqq2ASe1CcYBILZ1seRYbQa6ePF8qhYNTBwRZEps8DuRpTK/fT5BuBqtWlil8vYSeABCjQbq1/iVnW7wWpr+W7kMf9krSn1zK/x0GfEhFne0i/vpRE874ug2pS93Iuskpp3WI=
Message-ID: <7b9198260805211201g60dd6a15ib4e27d017b292992@mail.gmail.com>
Date: Wed, 21 May 2008 20:01:43 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080521175829.GA10648@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com>
	 <20080520173503.GA10811@c2.user-mode-linux.org>
	 <Pine.LNX.4.61.0805201751500.13532@chaos.analogic.com>
	 <20080521021502.GB16212@c2.user-mode-linux.org>
	 <7b9198260805210502i316c9e38lcc9b5561045dd5d@mail.gmail.com>
	 <7b9198260805210504h278f014s5aba720360ac02ab@mail.gmail.com>
	 <20080521175829.GA10648@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Jeff Dike <jdike@addtoit.com>:
> On Wed, May 21, 2008 at 01:04:21PM +0100, Tom Spink wrote:
>> Oh No! I forgot to get rid of those nasty includes.... Take 2....
>
> This is actually supposed to return the address space top, not the
> size, so I changed the name and return value accordingly.
>
> Other than that, this is fine.  The final result is below...
>
>                      Jeff
>

Awesome!  Thanks for your help, Jeff.

-- 
Tom Spink
