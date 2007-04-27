Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXD0Fl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXD0Fl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXD0Fl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:41:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:65441 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbXD0Fl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZtRfQeQXrcq6LOjOaza338VnvRrbSGGgeAZwAjVU/eMbhPZeoywXmB8Sg/IGug2eDd0XP2eAHaeRy1f+VW3eztWughbu/ci6UFkrrDE0CTKXKrKNVRgzPrjgKNTAbmNsnjL4i3CXDFxVwtTjkT61m7Nb9BqV+OFZhNjncwy77s8=
Message-ID: <84144f020704262241s5bcfc043k55f9d60e368b3c9e@mail.gmail.com>
Date: Fri, 27 Apr 2007 08:41:56 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Back to the future.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070426224005.GA21926@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <20070426224005.GA21926@elf.ucw.cz>
X-Google-Sender-Auth: d28dd873e620d43a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> Now, it would be _very_ nice to be able to snapshot system and
> continue running, but I just don't see how to do it without extensive
> filesystem support.

So what kind of support do we need from the filesystem?

                                              Pekka
