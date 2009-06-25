Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZFYKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZFYKuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZFYKuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:50:07 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:34435 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFYKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BjEojP2x1qfWQQAsiMWrd07eGmFpzWHLHP0i4g5UVJJMtmgjOykf1MguPLJ72D7nqT
         QG7rfNkyMKrfgA7IHm3QvfKj289de2MufHG5jfv77S3VGWRlwXnQBWABQDcYaTI9HxoU
         L0L/9wUIj9VjiMLQgEylW7xDu3B8OiOIOByFU=
Date: Thu, 25 Jun 2009 18:52:12 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Paul Menage <menage@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090625105212.GH6374@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <4A3F4448.30502@panasas.com> <20090625135901.a028512d.sfr@canb.auug.org.au> <4A432DD4.3010905@panasas.com> <6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com> <4A43309A.3060306@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A43309A.3060306@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 25, 2009 at 11:08:58AM +0300, Boaz Harrosh wrote:
>On 06/25/2009 11:06 AM, Paul Menage wrote:
>> On Thu, Jun 25, 2009 at 12:57 AM, Boaz Harrosh<bharrosh@panasas.com> wrote:
>>> Paul? we did not receive any feedback from you
>> 
>> I split it out into two patches and sent them about an hour ago. (One
>> for mmu_context.h sent to Rusty and one for the other two fixes, sent
>> to Linus)
>> 
>> Paul
>
>Thanks ... :-)

yeah, that is better, well done!

Thanks.
