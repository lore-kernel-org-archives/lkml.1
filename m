Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZKQSNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZKQSNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZKQSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:13:54 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34697 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZKQSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tbl80GJFGwYXpSqa3ZUAYklEH8rYMFVOm+XE9GEovZ9QP6BMokOLlA0ojlk2JU7xHk
         YI/X3rZHtClVR9yqz5sK17qlDhBHxDguYtvcJILa0bx8uBpee+ZwQsLQYJWb24tSGG9N
         hPwLmMOagzVJopzVbqf754aLSEKI/+azeumrM=
Date: Tue, 17 Nov 2009 19:13:57 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091117191357.7c64ba70.kristoffer.ericson@gmail.com>
In-Reply-To: <4B02E64D.2010700@gmail.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.yiC._ndALB@chimera>
	<4B01F3FE.8040707@gmail.com>
	<20091117113320.8aef894a.kristoffer.ericson@gmail.com>
	<4B02E64D.2010700@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 10:07:09 -0800
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Kristoffer Ericson wrote:
> >
> >
> > Im still hitting this so basicly using 2.6.30 until it get sorted. Will try and make
> > some time to test the different commits. Last time I waited for it to disconnect which
> > could take 10-40min. Since it depends on the network load Im now going to increase
> > the load to see if I hit it quicker (and thus finding the error commit).
> >
> > So in short, its still valid and I will try and make time to fix it :)
> >
> >
> >
> >    
> o.k. so it is something that is enough to
> cause an inconvenience.

Especially if you are using your computer as a router to other computers
and they start screaming every time internet goes down. :(

> 
> Justin P. mattock


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
