Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYGTMf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYGTMf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYGTMfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:35:47 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:65164 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbYGTMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gtklY6dEVQX6b7KNpNXF++VBBR7pfevdS3o8G7Sowj2dSht004MEsVKQY1rU4MmyJY
         IPsBSTqRJk3rW13l2PsHNjN1csBJrvzTQFAymfY7aQJEi9HvCZM2xWwPpgQOG8zyXNzQ
         Qel2JR2AHP2O+IaB02YfM2fJ85SkyebpiZV/w=
Message-ID: <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>
Date: Sun, 20 Jul 2008 09:35:45 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: Please add ZFS support (from GPL sources)
Cc: "Jeff Garzik" <jeff@garzik.org>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080720105724.GA8921@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
	 <487FA143.9010109@garzik.org> <20080720105724.GA8921@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 7:57 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jul 17, 2008 at 03:45:07PM -0400, Jeff Garzik wrote:
>> Fred . wrote:
>>> Previously we have not been able to have ZFS support due to it being
>>> licensed under the CDDL and the kernel under the GPL.
>>>
>>> Sun have contributed ZFS support to GRUB under the GPL license. We
>>> could now use that code to implement support for ZFS in the Linux
>>> kernel.
>>>
>>> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
>>
>> Linux needs btrfs upstream more than it needs ZFS...
>
> Don't be so harsh.  Adding a read-only for the start zfs driver for
> Linux would be useful for various purposes.  And adding read-only
> filesystems to Linux is really easy.  So if Fred really cares about it
> I'd be very happy to mentor him implementing it.  IT should be a very
> good learning exercise for him.

If Fred declines, is anyone free to take you up on the offer?  I have
no filesystem experience and almost no experience with kernel code in
general, so I would not be anyone's first choice for a task like this.
 However, since it mainly appears to be an integration exercise (using
the code from GRUB and making it work in linux), it might well be
doable for me.  As a bonus, being highly inexperienced, I have no
expectations of doing anything correctly, and thus would not react
badly to lots of criticism.

So to summarize - if anyone else would like to undertake this work,
they probably should.  But if no one has the time/will, then I would
be happy to give it a try.

Thanks,
-- 
Kevin Winchester
