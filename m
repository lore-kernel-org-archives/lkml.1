Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0BTPeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:34:13 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:44674 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab0BTPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aF34/9HNK5ahleXtHSgGHMy3Wz/DPZMlhdYy1JaYCLEKzRVMtg5/NAG6VYNDFm8RHh
         fWpFTnkozAQyZAeskGdCzAZefkUu5L5n+n1khbO06rEKS7ODllUf1pYnySGZWffelK/L
         OhPo8gd768tMmhH7TQWTJZqQMevkuNsOVvXFk=
Date: Sat, 20 Feb 2010 23:36:54 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] um: tell git to ignore generated files
Message-ID: <20100220153654.GL3000@hack>
References: <20100220143359.GD3000@hack> <20100220150936.GP30031@ZenIV.linux.org.uk> <20100220151605.GQ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220151605.GQ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 03:16:05PM +0000, Al Viro wrote:
>On Sat, Feb 20, 2010 at 03:09:36PM +0000, Al Viro wrote:
>> On Sat, Feb 20, 2010 at 10:33:59PM +0800, Am??rico Wang wrote:
>> > 
>> > git should ignore these files, since they are generated.
>> 
>> > +include/shared/kern_constants.h
>> > +include/shared/user_constants.h
>> 
>> I have patches taking that to include/generated, actually
>
>BTW, what's the status of skas4?  I have a series of patches leading towards
>resurrection of uml/powerpc (skas0), but I'd rather avoid breaking skas4
>in process...  Where does the recent version of that thing live?

I have no idea, maybe it is still in draft? Jeff?

Thanks.

