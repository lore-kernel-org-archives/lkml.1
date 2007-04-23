Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXDWJf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXDWJf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXDWJf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:35:59 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48471 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965691AbXDWJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:35:58 -0400
Message-ID: <462C7D74.60003@gmail.com>
Date: Mon, 23 Apr 2007 11:33:40 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com>	<20070404123311.GA18552@infradead.org>	<1175698135.5815.447.camel@violet>	<20070404150231.GE27660@stusta.de>	<4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com>
In-Reply-To: <4613D492.2070404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2007 06:38 PM, Rene Herman wrote:

Rusty?

> On 04/04/2007 06:00 PM, Alan Cox wrote:
> 
>>> Given that people seem to agree that authorship information has no 
>>> place in the binary, that might actually be best.
>>
>> Authorship information is very useful in the binary, especially when you
>> have to get lawyers involved in explaining things to people.
> 
> Okay.
> 
>>> So, MODULE_AUTHOR be gone?
>>
>> Not if I have anything to do with it. Putting maintainer in is not a
>> bad idea but that assumes it gets maintained, the beauty of _AUTHOR
>> is that it's generally right and stays that way or approximately so.
> 
> Case in point; someone is working with me in private on a new "mitsumi" 
> legacy CD-ROM driver. He's authoring the actual driver and upto now I've 
> just been doing some peripheral module infrastructure work. Given that I 
> have the hardware to test the thing, I'll be the maintainer though.
> 
> Adding myself as a MODULE_AUTHOR would be largely incorrect and adding 
> myself as the _only_ MODULE_AUTHOR would be so factually incorrect I 
> wouldn't, even if only from a credits point of view. Yet I do want to 
> make sure people contact me, and not the MODULE_AUTHOR (which will 
> happen no matter the MAINTAINERS file).
> 
> Other cases-in-point; I've lately been rummaging through sound/isa a 
> bit. Nothing much copyrightable again but especially in those situations 
> where (some of the) original authors are no longer active, I do again 
> want people to contact me about them if needed. And all the "which one 
> of the three people listed here is maintaining this" is yet another.
> 
> MODULE_AUTHOR may be approximately right but especially with old drivers 
> it also has little relation with who's maintaining the thing.
> 
> If MODULE_AUTHOR stays, can I just have MODULE_MAINTAINER please? It 
> doesn't need to be added to drivers directly, it can just grow (and 
> being inside the code, I suppose it'll likely stay up to date better 
> than the MAINTAINERS file).

Rene.

