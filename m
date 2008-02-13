Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbYBMP5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbYBMP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbYBMP5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:57:01 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:36319 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbYBMP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:57:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=Iqu2hcC+pvKmcuqPMUCVyu8SbzaOBvjoN3ureyFJcCeTlMjGhVFAt9zpeTGpVhznRz2PyBuhDiDDH1Ugz28GPMQedG7+viHjdsNYOk0MiD0KAn0xSnzm04yxUOAdmrialDpjX43NQb1v8fzxFsRX5IDt3zW12hPgvSeKE+FdbvA=
Date: Wed, 13 Feb 2008 10:56:40 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Linux Compatible USB Adapter Recommendations? [OT]
In-Reply-To: <644725.69797.qm@web52504.mail.re2.yahoo.com>
Message-ID: <alpine.LRH.1.00.0802131050050.4526@mini.warudkars.net>
References: <644725.69797.qm@web52504.mail.re2.yahoo.com>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2008, Marc Perkel wrote:

> I'm looking to buy a wireless USB adapter that I can
> plug into a Fedora 8 box. The main feature I want it
> to be able to stick it in and have it just work. No
> custom kernel compiles. If it had 802.11n that would
> be a plus. 
> 
> So - what "just works" with Linux?
> 

I use this Belkin one which has a RaLink chipset -
http://catalog.belkin.com/IWCatProductPage.process?Product_Id=179211 

It is not .11n but I never had any problems with Fedora 8 or Ubuntu 7.10 - 
well apart from fiddling with module blacklists that is. (This card is 
claimed by two drivers in the kernel and the one that gets loaded does not 
work - so I have to blacklist it.) But apart from that it just works - 
even with NetWorkManager.

Recently I was hunting for a .11n USB card that works with Linux without 
the ndiswrapper crap but wasn't able to find one.

You want to make sure though that you get the Ralink chipset with the card 
revision you buy - similarly named different version cards having totally 
different chipsets is not considered weird in that world. 

Parag 
