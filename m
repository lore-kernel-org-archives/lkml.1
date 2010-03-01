Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0CAXoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:44:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35988 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0CAXoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:44:15 -0500
Message-ID: <4B8C5139.3000701@zytor.com>
Date: Mon, 01 Mar 2010 15:43:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com> <20100301190341.GD12867@redhat.com> <4B8C1320.6060602@redhat.com> <4B8C4032.7080703@zytor.com> <4B8C463B.7070900@zytor.com> <4B8C4F12.8050009@redhat.com>
In-Reply-To: <4B8C4F12.8050009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 03:34 PM, Zachary Amsden wrote:
> 
> But I'd rather implement a new language where acquisition of resources 
> such as locks, dynamically allocated objects, and ref counts are 
> predicated in the function typing and are heavily encouraged to possess 
> defined inverses.  Then the closure of a particular layer of nesting 
> already has enough information to provide release upon escape, and the 
> compiler can easily take the burden of checking for a large class of 
> lock and resource violation.
> 
> And it would have to be prettier than the current languages that do 
> that, meaning operator overloading would be banned.  Although it would 
> define rational numbers, super-extended precision arithmetic, imaginary 
> numbers, quaternions and matrices as part of the spec, so there would be 
> no need to use arithmetic overrides anyway, and then all the nonsensical 
> operators could die, die, die, especially the function () and logical 
> operator overrides.
> 

/me takes away Zach's caffeine.

	-hpa

