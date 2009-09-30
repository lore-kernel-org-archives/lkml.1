Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZI3Oaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZI3Oaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZI3Oaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:30:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59543 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZI3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:30:51 -0400
Date: Wed, 30 Sep 2009 10:29:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gonsolo <gonsolo@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, kernel-team@lists.ubuntu.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: ath5k suspend
Message-ID: <20090930142924.GB3835@tuxdriver.com>
References: <4AC22B64.8050909@googlemail.com> <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com> <4AC35CA0.5070401@googlemail.com> <20090930140905.GA3193@tuxdriver.com> <4AC36A46.7010209@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC36A46.7010209@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 04:25:10PM +0200, Gonsolo wrote:
> Am 30.09.2009 16:09, schrieb John W. Linville:
>> On Wed, Sep 30, 2009 at 03:26:56PM +0200, Gonsolo wrote:
>>>>> Is it possible to add
>>>>> http://patchwork.kernel.org/patch/38550/
>>>>> to karmic? Otherwise karmic would be broken for me/my notebook/my
>>>>> wireless pccard.
>>>>
>>>> Since Karmic tracks the 2.6.31 -stable kernels, it's worth reporting
>>>> this upstream (CC'd) instead, particularly if it's a regression from a
>>>> previous kernel version, using the same ath5k driver...?
>>>
>>> I did that, too. ;) Hopefully it will be in 2.6.31.2.
>>
>> Maybe I missed it, but did you actually request the -stable team to
>> take the patch?  -stable helps more than just Ubuntu... :-)
>
> I requested it in Ubuntu and stable in two separate emails, just to be  
> sure it will be there when I am going to upgrade. ;)
> I apologize if I caused confusion or doubled your amount of work.
> Maybe I should have done this in one email to both parties.

Not really a big deal -- still, one email would tend to reduce confusion. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
