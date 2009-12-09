Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZLIVS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZLIVS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZLIVSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:18:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZLIVSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:18:53 -0500
Message-ID: <4B201428.9060701@redhat.com>
Date: Wed, 09 Dec 2009 16:18:32 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Dan Merillat <dan.merillat@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com> <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com> <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com> <4B0DDFDA.1030905@redhat.com> <c0c067900912022016u32e393cw3fe9e04ba1051253@mail.gmail.com> <c0c067900912071249y68c4c2bby90202bd5f467ea2c@mail.gmail.com> <20091209204803.GD29575@khazad-dum.debian.net>
In-Reply-To: <20091209204803.GD29575@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 03:48 PM, Henrique de Moraes Holschuh wrote:
> On Mon, 07 Dec 2009, Dan Merillat wrote:
>>>> Can you try out the patch from
>>>> http://lkml.org/lkml/2009/11/25/467 ?
>>
>> After a week of testing, that seems to have been the issue, thanks!
>
> In that case, is that patch being considered for stable@ ?

That may be an option, after Andrew has submitted the patch
to Linus for 2.6.33, which he typically does towards the end
of the merge window.

I will certainly ask the Fedora kernel maintainers to take
the patch in for their 2.6.32 based kernel.

-- 
All rights reversed.
