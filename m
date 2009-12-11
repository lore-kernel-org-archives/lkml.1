Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZLKDiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZLKDiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZLKDiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:38:23 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:54368 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZLKDiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=st+ohmA6FAn951SbAQzM4plLhVNgtYuRWbEqNcHpkjibY5Hr/6Sa6aeJsNRX9o8nkd
         NtxJny55UlDYz/dixqscCyDReXpJszLZWeAz8OfvZXSxqs2af9B6LsHGDIEDTG+ilCli
         D/5MtGzxf2V2UiQW+W6bglvZ895P057bln1Rs=
MIME-Version: 1.0
In-Reply-To: <2375c9f90912101922g5b31e5c9gceeca299b9c2b656@mail.gmail.com>
References: <2375c9f90912090238u7487019eq2458210aac4b602@mail.gmail.com>
	 <Pine.LNX.4.64.0912091442360.30748@sister.anvils>
	 <2375c9f90912092259pe86356cvb716232ba7a4d604@mail.gmail.com>
	 <Pine.LNX.4.64.0912100951130.31654@sister.anvils>
	 <2375c9f90912101922g5b31e5c9gceeca299b9c2b656@mail.gmail.com>
Date: Fri, 11 Dec 2009 11:38:28 +0800
Message-ID: <2375c9f90912101938hd0a358bl575a11cb9f6c5094@mail.gmail.com>
Subject: Re: An mm bug in today's 2.6.32 git tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 11:22 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Dec 10, 2009 at 5:56 PM, Hugh Dickins
> <hugh.dickins@tiscali.co.uk> wrote:
>> On Thu, 10 Dec 2009, Américo Wang wrote:
>>> On Wed, Dec 9, 2009 at 10:49 PM, Hugh Dickins
>>> >
>>> > Thanks for the report.  Not known to me.
>>> > It looks like something has corrupted the start of a pagetable.
>>                                  no, not the start
>>> > No idea what that something might be, but probably not bad RAM.
>>> >
>>> >>
>>> >> Please feel free to let me know if you need more info.
>>> >
>>> > You say you saw it twice: please post what the other occasion
>>> > showed (unless the first six lines were identical to this and it
>>> > occurred around the same time i.e. separate report of the same).
>>> >
>>>
>>> Yes, the rest are almost the same, the only difference is the 'addr'
>>> shows different addresses.
>>
>> Please post what this other occasion showed, if you still have the log.
>
> Sure, below is the whole thing.

If that doesn't look pretty, please use this one:

http://pastebin.ca/1710512

Thanks!
