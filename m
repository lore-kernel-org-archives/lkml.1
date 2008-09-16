Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYIPOch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYIPOch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYIPOc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:32:29 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:5083 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYIPOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o6BUW5aM1O8HDATcO7bZi0eqM6v1jDj7J0mj/Qyxc1yTZWQaKaS3PfiyZbB7rXoXrt
         B7JQiB3GEfIzLNSztXSvYbQuUrfLTpNYIeuGhbSeUaq2Q0vCYGg7zMnyfyypuWw7P4qj
         4JkZMF8dpbGJeDZkMpLtsbeMoXdhJekfN0iPQ=
Message-ID: <ab40e9c0809160732y2ff1ac23q7f2ae3c37425fbfd@mail.gmail.com>
Date: Tue, 16 Sep 2008 16:32:27 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: looking for a function
Cc: "Bernd Petrovitsch" <bernd@firmix.at>, linux-kernel@vger.kernel.org
In-Reply-To: <20080916071847.4a6ed31c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
	 <1221573632.6103.83.camel@spike.firmix.at>
	 <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
	 <20080916071847.4a6ed31c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

thanks,
I will try that!

Best regards,

Yang

2008/9/16, Arjan van de Ven <arjan@infradead.org>:
> On Tue, 16 Sep 2008 16:11:10 +0200
> "Xu Yang" <risingsunxy@googlemail.com> wrote:
>
> > Hi Bernd,
> >
> > thanks for you reply.
> >
> > yes, I know the thread migrates all the time, this is exactly what I
> > would like to observe. I would like to learn about the thread
> > migration of some specific scheduling algorithm. so ....
> >
> > any idea about the function?
>
> the getcpu() system call will do what you want.
>
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
