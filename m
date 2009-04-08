Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbZDHOSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbZDHOSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZDHOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:14:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52618 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933653AbZDHOOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:14:30 -0400
X-Sasl-enc: OuCcmyXEPXN6cz+sbhmzhLvGXJo2VsXNLv3TrqOxaxKF 1239200067
Message-ID: <49DCB140.7000603@fastmail.fm>
Date: Wed, 08 Apr 2009 15:14:24 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu>
In-Reply-To: <20090408140637.GC12931@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jack Stone <jwjstone@fastmail.fm> wrote:
>
>   
>> Fixed patch
>>
>> Thanks,
>>     
>
> Hm, what was fixed?
>   
I removed casts on pointer arithmetic which probably still needed to be
there to do the arithmetic properly.
>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>>     
>
> Btw., the canonical format is Signed-off-by. (note the 
> capitalization)
>   
Will note for the future.

Thanks,

Jack
