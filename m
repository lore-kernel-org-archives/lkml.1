Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870Ab0AVQVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0AVQVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129Ab0AVQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:21:52 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54389 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0AVQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nz5E4Xg+c9YdAkwHiJuPeFAYqynIuDaZWRWHRn7SzTpA1ZVM9exQaSYzgWfXzhheyZ
         I2MOVwCWuvLC5w6HDeocwpXqnCETv0gZA9AvQBgw3Ton+yhTQx3HJCex82wyNZKnRdRh
         UsZW9DvcZtlis92BPZs+VavPZ9FsQpLgMYC6Q=
Date: Sat, 23 Jan 2010 00:23:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Dimitry Golubovsky <golubovsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Current status of UML development?
Message-ID: <20100122162356.GA4771@hack>
References: <bcba51a1001211227y1cbe9020k5079367f05dd17a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcba51a1001211227y1cbe9020k5079367f05dd17a1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 03:27:58PM -0500, Dimitry Golubovsky wrote:
>Hi,
>
>I am learning/experimenting with UML internals, and am curious what is
>the current status of its development? Has UML become stable enough so
>it does not need any improvement (at least for i386), or has its
>development just ceased in favor of other virtualization techniques?
>

Of course not.

>Also I am trying to find recent papers covering modern UML's principles of
>functioning (especially the skas0 mode when /proc/mm is not
>available), but most of the papers that Google returns date back to
>2001 - 2003, and often state that "each UML process gets its own host
>process" that does not seem correct these days.
>

Yeah, I think we still don't have a fully support for that,
welcome to work on it.

Thanks.


-- 
Live like a child, think like the god.
 
