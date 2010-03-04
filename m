Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0CDOf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:35:27 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:53497 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0CDOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:35:25 -0500
Message-ID: <4B8FC4F1.70605@xs4all.nl>
Date: Thu, 04 Mar 2010 15:34:25 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100225 Fedora/3.0.2-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.2
MIME-Version: 1.0
To: Andre Prendel <andre.prendel@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 2.6.33 on jetway nc81-lf board
References: <4B8C0598.2060000@xs4all.nl> <20100302213709.951ee97b.akpm@linux-foundation.org> <20100304091741.GA1995@andre-laptop>
In-Reply-To: <20100304091741.GA1995@andre-laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 10:17 AM, Andre Prendel wrote:
> On Tue, Mar 02, 2010 at 09:37:09PM -0800, Andrew Morton wrote:
>> (cc lm-sensors)
>>
>> On Mon, 01 Mar 2010 19:21:12 +0100 Udo van den Heuvel <udovdh@xs4all.nl> wrote:
(....)
>>> No other sensor-related modules are loaded.
>>>
>>> What could be wrong?
> 
> See lm-sensors FAQ Chapter3 #39:
> 
>   http://www.lm-sensors.org/wiki/FAQ/Chapter3#Mysensorshavestoppedworkinginkernel2.6.31

Thanks, but the explanation implies no real fix other than more
consciously choosing to put system stability at risk.
Is a better fix in the making?

Kind regards,
Udo
