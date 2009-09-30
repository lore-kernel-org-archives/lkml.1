Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZI3OZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZI3OZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZI3OZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:25:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63122 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZI3OZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=saY0SirsFZQbe9jTXHJ8AAM6939Jxkl/+aXnfVW885/poyA8Da709f/j0qcspMidfy
         UxHhJlN6x0xbpOwV5lvy2mDL6gfF5xPaQ3Kornin9UJwOhVWm3+mfeu9+MfJfXgF3r7/
         YHhQx0UJBOXq6ZGiW2LravkEexBV7p9I35Rio=
Message-ID: <4AC36A46.7010209@googlemail.com>
Date: Wed, 30 Sep 2009 16:25:10 +0200
From: Gonsolo <gonsolo@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gonsolo <gonsolo@gmail.com>, Daniel J Blueman <daniel.blueman@gmail.com>,
       kernel-team@lists.ubuntu.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: ath5k suspend
References: <4AC22B64.8050909@googlemail.com> <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com> <4AC35CA0.5070401@googlemail.com> <20090930140905.GA3193@tuxdriver.com>
In-Reply-To: <20090930140905.GA3193@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.09.2009 16:09, schrieb John W. Linville:
> On Wed, Sep 30, 2009 at 03:26:56PM +0200, Gonsolo wrote:
>>>> Is it possible to add
>>>> http://patchwork.kernel.org/patch/38550/
>>>> to karmic? Otherwise karmic would be broken for me/my notebook/my
>>>> wireless pccard.
>>>
>>> Since Karmic tracks the 2.6.31 -stable kernels, it's worth reporting
>>> this upstream (CC'd) instead, particularly if it's a regression from a
>>> previous kernel version, using the same ath5k driver...?
>>
>> I did that, too. ;) Hopefully it will be in 2.6.31.2.
>
> Maybe I missed it, but did you actually request the -stable team to
> take the patch?  -stable helps more than just Ubuntu... :-)

I requested it in Ubuntu and stable in two separate emails, just to be 
sure it will be there when I am going to upgrade. ;)
I apologize if I caused confusion or doubled your amount of work.
Maybe I should have done this in one email to both parties.

g
