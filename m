Return-Path: <linux-kernel-owner+w=401wt.eu-S934090AbYEUB70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbYEUB70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbYEUB7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:59:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:46992 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbYEUB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HTQXmOCvFLP2+rIrJLnUAm/n0PIiKLCpG84jl4nZiuthBAc0gsRmmGpL7Le7mXhb4bZq6ZjTey9GGGGoKhHq+CceqVyJtYdo0N8KrNuFhtURDda6izE67brcnqvHOa6Nd8pji7Wdf3XRRUhOffIEziLNBrAeVb02aQh0unnn/aU=
Message-ID: <86802c440805201859g649a0abblf76aec92c2c7344b@mail.gmail.com>
Date: Tue, 20 May 2008 18:59:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: aperture_64: use symbolic constants
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080520154215.GA15494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519123952.GA23118@elf.ucw.cz>
	 <20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz>
	 <20080520154215.GA15494@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 8:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pavel Machek <pavel@ucw.cz> wrote:
>
>> Hi!
>>
>> > * Pavel Machek <pavel@suse.cz> wrote:
>> >
>> > > Use symbolic constants in aperture_64.c where possible (and make a
>> > > comment slightly more helpful).
>> >
>> > this code has already been changed in the latest -tip tree:
>> >
>> >    http://people.redhat.com/mingo/tip.git/README
>> >
>> > iommu/gart code is covered by the tip/x86/gart subtopic, which carries 7
>> > commits right now:
>>
>> Thanks, I have a copy now. And this one is relative to it:
>>
>> ---
>>
>> Factor-out common aperture_valid code.
>
> applied, thanks Pavel.

can you change the titile?

YH
