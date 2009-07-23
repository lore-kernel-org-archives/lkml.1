Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZGWQ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZGWQ3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZGWQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:29:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44634 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbZGWQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:29:30 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
From: Andi Kleen <andi@firstfloor.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
	<20090723172559.e7aebbb5.sfr@canb.auug.org.au>
	<20090723003228.fc0ec34b.akpm@linux-foundation.org>
	<20090723173852.119c04c2.sfr@canb.auug.org.au>
Date: Thu, 23 Jul 2009 18:29:25 +0200
In-Reply-To: <20090723173852.119c04c2.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Thu, 23 Jul 2009 17:38:52 +1000")
Message-ID: <87zlav1hy2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Andrew,
>
> On Thu, 23 Jul 2009 00:32:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> It gets easy if I remove linux-next.patch from -mm.  Maybe I'll do that.
>
> At that point we could add the "stable" part of -mm to linux-next :-)

I think that would be a great idea. It always bugged me that
if Andrew pulls something in it's not automatically tested in -next.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
