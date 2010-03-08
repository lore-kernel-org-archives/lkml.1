Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab0CHG2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:28:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41132 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CHG2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EUOSg53E3nixpgje1wyek0FGmDrQQmzASC+jjbj2TxfP9uaTpbDu9pDkjaOWV8qoIQ
         svVzGVt32G/AY98pd9OhYvXtWTrkZAP/kz53TAMj4L+mpJKGQ61SQAfBSm57bNknUpoK
         DgD41QBb6ZePyOpW6vaB+3XiQv1GqpMW1cHfg=
MIME-Version: 1.0
In-Reply-To: <1264522249.3067.79.camel@odin>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
	 <20100112115156.GA546@rakim.wolfsonmicro.main>
	 <771cded01001250301q465a9f8ma484f597ae9a292f@mail.gmail.com>
	 <20100125135628.GB26613@rakim.wolfsonmicro.main>
	 <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
	 <20100126110420.GI15759@rakim.wolfsonmicro.main>
	 <771cded01001260354y7c7db25bqa8bbfe000e0c0380@mail.gmail.com>
	 <20100126120058.GN15759@rakim.wolfsonmicro.main>
	 <771cded01001260414q4c8df1e0k303772b87bc725eb@mail.gmail.com>
	 <1264522249.3067.79.camel@odin>
Date: Mon, 8 Mar 2010 01:28:39 -0500
Message-ID: <771cded01003072228i1a6249f0tc0026794cc512bd2@mail.gmail.com>
Subject: Re: [PATCH 01/01] regulator: support max8649
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:10 AM, Liam Girdwood <lrg@slimlogic.co.uk> wrote:
> On Tue, 2010-01-26 at 07:14 -0500, Haojian Zhuang wrote:
>> On Tue, Jan 26, 2010 at 7:00 AM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> >
>>
>> update this patch.
>>
>
> Applied.
>
> Thanks
>
> Liam
>
>

Hi Liam & Mark,

I just want to confirm whether max8649 is merged into regulator
codebase. It seems that I can't find max8649 in regulator git tree.

Thanks
Haojian
