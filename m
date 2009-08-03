Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZHCNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZHCNYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZHCNYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:24:51 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45117 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZHCNYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nzP9XbinQsu9AUJYiGHY1BSzGsQjBTEVES1IciN71SkEkuVk1wxaZxYdV+R3SgoEcM
         a9wdsgPdtoAnr7MOY4126JvMVQxDn7axyq8yvMvYCvvhTeZDSRn/o0SkLZdvvw1BSc/W
         JFDVC/cwKSmm/gUo9rCO8hOL2RcbsuwH1ZCSU=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <4A76E3E8.30902@nets.rwth-aachen.de>
References: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
	 <4A76E3E8.30902@nets.rwth-aachen.de>
Date: Mon, 3 Aug 2009 16:24:49 +0300
X-Google-Sender-Auth: 8320e4777915eb24
Message-ID: <11fae7c70908030624q11ffd29ened3c77ec4c4ca79a@mail.gmail.com>
Subject: Re: x86 Geode issues in kernel >= 2.6.23 and >= 2.6.31-rc4
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 4:19 PM, Arnd
Hannemann<hannemann@nets.rwth-aachen.de> wrote:
> Martin-Éric Racine wrote:
>> (non-subscriber post; please keep me in CC)
>>
>> Greetings,
>>
>> Having previously reported two issues via Ubuntu's bug tracker and not
>> found any answer, I thought I'd approach the LKML with the issues at
>> stake.
>>
>> 1) Since kernel 2.6.23, one cannot boot hardware based on the Geode
>> SCx200 series. Partial answers about the most plausible cause have
>> been found by the target hardware's manufacturer as explained at
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/241307
>>
>> 2) Since kernel 2.6.31-rc4, one cannot boot hardware based on the
>> Geode LX800 as described at
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/396286
>>
>> In case either of these issues was already reported and there is a
>> know fix or work-around, I'd love to hear more. Otherwise, please feel
>> free to contact me for additional details.
>>
>
> Just to give a data point:
> 2.6.31-rc1,2,3,4,5 were/are running all fine on my Geode LX800
> (http://www.pcengines.ch/alix2d2.htm) so it seems something
> board or .config specific.

Thank you for your answer, Arnd.

Could you please send me a copy of your .config so that I can compare
it with the one used on Ubuntu kernels?

Martin-Éric
