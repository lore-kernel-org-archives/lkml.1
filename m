Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYGUOku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYGUOku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYGUOkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:40:40 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:56771 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYGUOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Sa6KwaNu9xHXxyzt8WkiKcG6UBQkgvaDnxMPNgkDWQSrEJELtcTPczq1DzQ3CxqrXc
         xOR0Azx0oQ+DgG03jUJJV998syoRELyJfWy2ZpLQq+3tQQjEF8i6lWZHmFMMotlND+mX
         Eq7ZvVBpgGj7GOga8B/4bNjuQiG1xTI8y+krU=
Message-ID: <d1af83620807210740vfef575bp73832fd95d803850@mail.gmail.com>
Date: Mon, 21 Jul 2008 11:40:38 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Fred ." <eldmannen@gmail.com>
Subject: Re: Please add ZFS support (from GPL sources)
Cc: "Christoph Hellwig" <hch@infradead.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <f188924b0807210723v3a35de9fgc1565811a0597833@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
	 <487FA143.9010109@garzik.org> <20080720105724.GA8921@infradead.org>
	 <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>
	 <20080721072801.GA6115@infradead.org>
	 <d1af83620807210439r6b8fa39bu4f3fd76c86aa548d@mail.gmail.com>
	 <f188924b0807210723v3a35de9fgc1565811a0597833@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added back CCs)

On Mon, Jul 21, 2008 at 11:23 AM, Fred . <eldmannen@gmail.com> wrote:
> On Mon, Jul 21, 2008 at 1:39 PM, Kevin Winchester
> <kjwinchester@gmail.com> wrote:
>> On Mon, Jul 21, 2008 at 4:28 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>> On Sun, Jul 20, 2008 at 09:35:45AM -0300, Kevin Winchester wrote:
>>>> If Fred declines, is anyone free to take you up on the offer?  I have
>>>> no filesystem experience and almost no experience with kernel code in
>>>> general, so I would not be anyone's first choice for a task like this.
>>>>  However, since it mainly appears to be an integration exercise (using
>>>> the code from GRUB and making it work in linux), it might well be
>>>> doable for me.  As a bonus, being highly inexperienced, I have no
>>>> expectations of doing anything correctly, and thus would not react
>>>> badly to lots of criticism.
>>>>
>>>> So to summarize - if anyone else would like to undertake this work,
>>>> they probably should.  But if no one has the time/will, then I would
>>>> be happy to give it a try.
>>>
>>> Yes, this offer is of course up to everyone interested.  But it's not
>>> purely an integration effort in the traditional sense, the grub
>>> filesystem interface is quite different from the Linux one, and the code
>>> structure and style is quite different.  But if you're willing to learn
>>> it should be very interesting.
>>>
>>
>> No one else seems to have volunteered, so I would certainly like to
>> give it a try.  I guess I need to get the ZFS grub code, create a ZFS
>> filesystem, and start looking around for information on linux
>> filesystem development and ZFS (obviously without looking at any CDDL
>> licensed code).
>>
>> Once I get a handle on that, I'll see where I can get before I need to
>> ask a thousand questions.
>>
> Code can be found here;
> * http://src.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/grub/grub-0.95/stage2/
>
> But it may be covered by patents by Sun. So maybe not allowed make an
> implementation. :(
> Maybe you should consult SFLC (Software Freedom Law Center) first or something.
>

I would have no idea of the legal implications here.  Do I really need
to get the lawyers involved just to use GPLv2 code from another
project in linux?

-- 
Kevin Winchester
