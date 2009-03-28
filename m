Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZC1C4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZC1C4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 22:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZC1C4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 22:56:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:64405 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZC1C4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 22:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t9omWpaOsk+jUL2QcxcF1rbQl96ZwDjhBy2iPPuRKooqd8nA0WQDoapkW4bWYlclJ2
         f+LoeoDuyx4jtfnzDcqr3VRDHRud6XDS97hNum4tuyqLNjiY7zv/9dWhwUOp1X4moozy
         wXvo5FiY753pHi5/LdLhsnf7EFAhIW1S1xdRQ=
MIME-Version: 1.0
In-Reply-To: <49CD9120.1010009@garzik.org>
References: <20090327051338.GP6239@mit.edu>
	 <20090327170208.GA27646@srcf.ucam.org>
	 <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
	 <49CD2C47.4040300@garzik.org>
	 <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
	 <49CD4DDF.3000001@garzik.org>
	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <49CD6CE6.3020309@garzik.org>
	 <alpine.LFD.2.00.0903271840450.3994@localhost.localdomain>
	 <49CD9120.1010009@garzik.org>
Date: Sat, 28 Mar 2009 02:56:38 +0000
Message-ID: <328e43f00903271956w1e10ec29p440d2c066e253c6e@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Zid Null <zidsoft@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Jeff Garzik <jeff@garzik.org>:
> Linus Torvalds wrote:
>>
>> On Fri, 27 Mar 2009, Jeff Garzik wrote:
>>>
>>> Definitely a difference!   1 for both, here.  Deb is a fresh OS install
>>> and
>>> fresh homedir, but my F10 has been through many OS and ff config upgrades
>>> over
>>> the years.
>>
>> Hmm. I wonder where firefox gets its defaults then.
>> I can well imagine that Debian has a different firefox build, with
>> different defaults. But if your F10 thing also is set to 1, and still shows
>> as "default", then that's odd, considering that mine shows 0.
>>
>> I have 'rpm -q firefox': firefox-3.0.7-1.fc10.x86_64.
>>
>> Is yours a 32-bit one? Maybe it comes with different defaults?
>>
>> And maybe firefox just has a very odd config setup and I don't understand
>> what "default" means at all. Gene says he doesn't have that
>> toolkit.storage.synchronous thing at all.
>
> In my case the toolkit.storage.synchronous is present in both, set to 1 in
> Deb and bolded and set to 1 in F10 (firefox-3.0.7-1.fc10.x86_64).

I compiled my own firefox under gentoo, not present.
Mozilla Firefox 3.0.7, Copyright (c) 1998 - 2009 mozilla.org

> The latter's bold typeface makes me think my F10 FF
> toolkit.storage.synchronous setting is NOT set to the F10 default --
> although I have never heard of this setting, and have certainly not manually
> tweaked it.  The only FF setting I manually tweak is cache directory.
>
>        Jeff
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
