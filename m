Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZEBSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZEBSOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZEBSNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:13:50 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:58188 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZEBSNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LrAZpz7EvZHifHNKWprbzzjIM0dfa6oW2fuO1rqrYraBVp3axh+c0sg3+VeH7aHs4X
         KmNxWb+REg94KRGAQybcHw1evUgfXK8ajP0sJAik4yYmkvamWopPyhE/IXwAES7xeOq5
         9byOxb5Pz38nWYW//0cyvcJPWneRstBvs5394=
MIME-Version: 1.0
In-Reply-To: <1241282682.13562.21.camel@johannes.local>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
	 <1241252825.13562.20.camel@johannes.local>
	 <f7848160905020420t114db70dq4018bab2ab53fc8f@mail.gmail.com>
	 <1241282682.13562.21.camel@johannes.local>
Date: Sat, 2 May 2009 14:13:47 -0400
Message-ID: <f7848160905021113v46de3367ge38ca92a4c26c8f1@mail.gmail.com>
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Parag Warudkar <parag.lkml@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2009-05-02 at 07:20 -0400, Parag Warudkar wrote:
>
>> > Can you make sure the txpower is set correctly, on your compat? Just say
>> > "iwconfig wlan0" or whatever _while_ associated -- and check that it
>> > reports 15dBm or so.
>>
>> It shows 27 dBm when associated - both for mainline and compat.
>
> Good.
>
>> Still get the disassociated messages.
>
> Right, different problem then. Can you put that into a kernel.org
> bugzilla please?
>

Done - http://bugzilla.kernel.org/show_bug.cgi?id=13223

Thanks
Parag
