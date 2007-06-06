Return-Path: <linux-kernel-owner+w=401wt.eu-S936068AbXFFWCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936068AbXFFWCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935134AbXFFWCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:02:00 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49602 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935226AbXFFWCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:02:00 -0400
Message-ID: <46672E09.9070102@gmail.com>
Date: Wed, 06 Jun 2007 23:58:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com> <466575EE.70901@goop.org> <46657988.6060901@gmail.com> <20070606212605.GA6711@ucw.cz>
In-Reply-To: <20070606212605.GA6711@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2007 11:26 PM, Pavel Machek wrote:

>> Yes, it's internal but given that this is open-source 
>> which, optimistically, is read many more times than it's 
>> written one should still strive for code that reads nice 
>> as far as I'm concerned. It's obviously also not hugely 
>> important but it's just that ZERO_SIZE_PTR makes my neck 
>> hair stand up.
> 
> PTR_TO_NOTHING? 
> PTR_TO_0BYTES?
> PTR_TO_0SIZE?
> PTR_TO_ZERO_SIZE?
> NOT_QUITE_NULL? :-)

Particularly like that one. Wouldn't object to that at all. Hey, they tell 
us it's just some inconsequential internal thingy anyway... :-)

> FULL? 

Almost as nice. DULL? BULL?

NOTHING?
EMPTY? <-- nice one as far as I'm concerned.

Rene.
