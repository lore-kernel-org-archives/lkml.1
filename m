Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYGGUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYGGUnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYGGUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:43:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbYGGUnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:43:17 -0400
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: "fb-defio: fix page list with concurrent processes"
References: <4856E38E.1040203@goop.org>
	<45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
	<m3mykyr7wf.fsf@crossbow.pond.sub.org>
	<45a44e480807031644vb5dcc31sf9558bffd772c8b9@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 07 Jul 2008 16:43:10 -0400
In-Reply-To: <45a44e480807031644vb5dcc31sf9558bffd772c8b9@mail.gmail.com> (Jaya Kumar's message of "Fri\, 4 Jul 2008 07\:44\:38 +0800")
Message-ID: <m3bq19e881.fsf@crossbow.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Fri, Jul 4, 2008 at 5:10 AM, Markus Armbruster <armbru@redhat.com> wrote:
>>
>> Jaya, any news?
>>
>
> Hi Markus,
>
> In the thread, as per your point:
>
>> better, somewhat slow code, or somewhat useless code?  I'd like to see
>> the fix merged as soon as possible.  You can always improve its
>> performance later.
>
> I responded:
>
>> Yup, I've got no problem if the old patch is requeued and merged.
>
> I'd assumed that you would requeue that patch.
>
> Thanks,
> jaya

Unfortunately, I missed that assumption of yours %-}

Still want me to post it for you?
