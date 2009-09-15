Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZIOIde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZIOIde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZIOIdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:33:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63731 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZIOIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aqLkBkuyWvwLNuRGP7awVDjoV8uUTeq2exLwVxcRuMOyRQxXvUIw9pEJBpPrurmXUX
         UP1fzQE+lDR1LRBz4tTnLMuLlLzBIIlHK/ufctrIbHEV3OLZmuHKAX4bz7fgo4+msgnw
         OdcJH9gYZhCBaO435RJLC0eK2XVdhgx8Rrifk=
MIME-Version: 1.0
In-Reply-To: <4AAF4A9E.3050101@redhat.com>
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
	 <20090528004100.3716e00d.akpm@linux-foundation.org>
	 <4A21EA8E.6060507@redhat.com>
	 <94a0d4530909130705o6886d496o670d1b978a9fc75f@mail.gmail.com>
	 <4AAF4A9E.3050101@redhat.com>
Date: Tue, 15 Sep 2009 11:33:32 +0300
Message-ID: <94a0d4530909150133r138e2afbm87b8191c848569ab@mail.gmail.com>
Subject: Re: [Patch] kbuild: fix a compile warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:04 AM, Amerigo Wang <amwang@redhat.com> wrote:
> Felipe Contreras wrote:
>>
>> On Sun, May 31, 2009 at 5:25 AM, Amerigo Wang <amwang@redhat.com> wrote:
>>>
>>> Andrew Morton wrote:
>>>>
>>>> On Fri, 15 May 2009 03:51:18 -0400 Amerigo Wang <amwang@redhat.com>
>>>> wrote:
>>>>
>>>>
>>>>> I got this warning:
>>>>>
>>>> With which gcc version?
>>>>
>>> gcc version 4.4.0 (GCC)
>>
>> I'm also getting this warning on 4.4.1. Can we merge this patch?
>>
>
> I believe we already merged this patch in
> commit d067aa7.
>
> Can you try the latest linus git tree?

Sorry, yeah, I realized I was using an old tag after I sent the mail. Thanks.

-- 
Felipe Contreras
