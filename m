Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXJWARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXJWARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXJWARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:17:44 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53540 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXJWARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:17:43 -0400
Message-ID: <471D3D05.9070801@keyaccess.nl>
Date: Tue, 23 Oct 2007 02:15:01 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Roel Kluin <12o3l@tiscali.nl>, Rik van Riel <riel@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
References: <471BF741.2020501@tiscali.nl>	 <20071021214209.1a7567d7@bree.surriel.com>	 <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>	 <471CE453.5050208@tiscali.nl>	 <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com>	 <471CF150.9090707@tiscali.nl> <471D23AA.2000803@keyaccess.nl> <2c0942db0710221600j24f76f68lefe562cc8bc2d067@mail.gmail.com>
In-Reply-To: <2c0942db0710221600j24f76f68lefe562cc8bc2d067@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2007 01:00 AM, Ray Lee wrote:

> On 10/22/07, Rene Herman <rene.herman@keyaccess.nl> wrote:

>> Hugely trust inspiring isn't it -- the amount of eyes and comments you'll
>> get even on trivial patches like this? This development model is working!
> 
> Go easy with the snarkiness, hmm? It's the trivial ones that seem to
> be the most dangerous. The larger ones actually get *tested*
> sometimes.

I was also commenting and don't generally on anything much more involved so 
any snarkiness included myself which should make things better.

>> Now if only we'd sometimes get some for non trivial patches as well...
> 
> That's certainly true regardless, but for myself, I'd rather throw
> some reviews out for the small ones since I have adequate time and
> knowledge for them. The larger ones require domain specific knowledge
> I lack, and time I don't have.

Exactly the problem. Comment was mostly triggered due to me looking at a 
problem with a proprietary CD-ROM driver again tonight that I posted a few 
months ago where the only comment has been from the fellow author. There the 
problem was the block layer blowing up and given that it seems unlikely that 
this wouldn't be a problem inside the newbie-driver itself, that the block 
part of it was actually really small and people said they'd look at it, the 
subsequent thundering silence still annoys me.

Ofcourse, now it seems the kernel itself has moved on enough that the driver 
doesn't work at _all_ anymore and I at the moment lack the time to spend the 
required hours googling around trying to find out what the heck changed out 
from under me so that I might get it to at least do what it already did do.

Hey, I don't actually know and maybe I'm just wrong but I have the feeling 
that over the last 1 or 2 years most new developers seem to be either people 
that are payed to be so, perhaps in the form of graduation, or janitors. The 
kernel is much, much more complex than even only a few years ago and at the 
same time the number of knowledgeable developers who'll do something other 
than their own thing and otherwise just wait around for something perfect to 
merge seems to be approaching zero.

That is -- I do not feel that the current developer base is expending overly 
many efforts to appear welcoming.

Please feel free to do the open-source thing and argue that's actually an 
advantage (there we have that snarkiness again...) or otherwise ignore me. 
I'll just sit here and be grumpy anyway. Might be better after a good 
night's sleep...

Rene.

