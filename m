Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZCDAIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZCDAIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZCDAId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:08:33 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:40390 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbZCDAIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kz6d6kDqIlfl80yFBD1cYLlTf+QlKZ7AhXepiBM5uzWtMw9LPk9l1AHqqUN2oNgBcN
         O+QREDvX0C+UkwjGmdI50dAVsKjXtYhe1vgRWHMsDWgzLaK/1klQSUazHU9yXbjmfTuK
         +/WXEvP+ERhJiuVG4DEMTRcBCO0INJJiPeBZo=
Date: Wed, 4 Mar 2009 01:06:59 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: some tc commands fail on 2.6.29-rc6-git5, works on 2.6.28.7
Message-ID: <20090304000659.GA4555@ami.dom.local>
References: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com> <20090301165729.8e08e1d7.akpm@linux-foundation.org> <49AC28FF.1040102@gmail.com> <a5d9929e0903031510r7f173f5cib7bd1a2426e92473@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0903031510r7f173f5cib7bd1a2426e92473@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 11:10:36PM +0000, Joao Correia wrote:
> Hello again
> 
> Sorry for taking so long, been busy with some unexpected work.
> 
> I have checked the .config and can not (to the extent of my not-guru
> knowledge) find anything out of place. Excuse me if its obvious and it
> didnt strike me yet.
...
> [root@duron ~]# tc -V
> tc utility, iproute2-ss090115
...

Joao, you don't need to be sorry at all - on the contrary I'm
extremely sorry! I was so focused on the kernel version but ignored
updating iproute, and it looks like this matters here.

So you're right. Alas I'll not be able to look at it until "tomorrow"
in the evening.

Thanks for the report,
Jarek P.
