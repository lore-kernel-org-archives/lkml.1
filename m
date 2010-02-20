Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0BTCQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 21:16:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58241 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0BTCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 21:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Cef3owm0opUGQ+E46JlnGEzxVwdRuQxCLEbHoBD/1bAWKuEW1vRV82ixlk2bjpN2+l
         oOyTA2zQMrpRvRx7dL7hlxrEUhDZT7ikRMNPmNiWKbT27S3C9Oikh8wuNr1gi+AFsxCl
         3mDAkF3sT/bCRzi43G98NhBZT2oE39T1mpqZY=
MIME-Version: 1.0
In-Reply-To: <4B7BEA41.6080303@suse.cz>
References: <4B5E5D4F.50803@windriver.com> <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com> 
	<4B5E9BE9.2030702@windriver.com> <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com> 
	<4B5EB223.60307@windriver.com> <4B6344CA.10504@suse.cz> <4B666982.1020007@windriver.com> 
	<4B6C8FF0.3090106@suse.cz> <daef60381002071855m7a5d6d2cg7b9a9a48b6aef20e@mail.gmail.com> 
	<4B7BEA41.6080303@suse.cz>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 20 Feb 2010 10:16:26 +0800
Message-ID: <daef60381002191816w4bc261cfq14b55aa7879b3f6e@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation 
	environments
To: Michal Marek <mmarek@suse.cz>
Cc: Hui Zhu <hui.zhu@windriver.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 21:08, Michal Marek <mmarek@suse.cz> wrote:
>
> On 8.2.2010 03:55, Hui Zhu wrote:
> > Hi Michael,
> >
> > Looks you miss this one:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef2b9b054580ef835078d8aa411bd06542cd5c1c
>
>
> That one is already in Linus' tree, so this is OK. BTW please don't
> top-post.
>

Got it.  Thanks Michael.

Hui
