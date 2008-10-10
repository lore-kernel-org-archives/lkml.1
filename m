Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbYJJLvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbYJJLvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYJJLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:50:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:26509 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYJJLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ixCLSCTmah2oG68J9cLRSC4DxI9dNiOU3G43xLBTj+2qhZb7DKpQEW3RoiXq1DLZz6
         ZT62YbGdeo+AsHmjb/b9dFtkH1l8VmrZbN1U4Ka2AI9VshdpOX2KThmntlWm5qh0yuCl
         ddb9ff4zaAQLZRa5fIeIERr1sm4df7AVALeLE=
Date: Fri, 10 Oct 2008 15:53:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Yudha Harimantoro T <yudha.ht@gmail.com>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Error : Linux-2.6.27
Message-ID: <20081010115342.GB25982@x200.localdomain>
References: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 03:26:44PM +0700, Yudha Harimantoro T wrote:
> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
> 2.6.27 patch and try to build it.
> 
> I build with `make oldconfig` and answer any question with default
> answer, I just press [enter].

Not wise.

> I build with `make`. No error and all compiled.
> Then I install with `make modules_install` and `make install`.
> 
> After reboot the system I got 'kernel panic'.
> This is the error picture :
> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
> Is it a bugs?
> 
> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
> [2.6.26.6 run well]

Post diff -U0 between old and new config.
