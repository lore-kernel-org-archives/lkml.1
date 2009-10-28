Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZJ1B4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZJ1B4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZJ1B4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:56:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:36108 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbZJ1B4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jUJLPkL6R2lGGGrXsI636ywWY/qEl/bfAbgHOPyhFYNvbSoMlYELwIAobXI045aswX
         UFEvPF2QuWiy+pE0coEJDnTzUUyc89tnyarYg+6kysjMsYmv0YJkZVBgWtlaUPSASI0C
         sYYOCoHBReljMny38Zor/BPO1dhG6MjaoqZ9s=
MIME-Version: 1.0
In-Reply-To: <200910280237.40268.marek.vasut@gmail.com>
References: <20091026225930.GA18723@localhost> <f17812d70910270043q328ab091mb1d76760e674450d@mail.gmail.com> 
	<200910280237.40268.marek.vasut@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 28 Oct 2009 09:55:59 +0800
Message-ID: <f17812d70910271855m4be6e4avcf90bfbbcb7ddb20@mail.gmail.com>
Subject: Re: [PATCH] 2.6.32-rc5 bug in Palm Tungsten C keyboard
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 9:37 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Dne Út 27. října 2009 08:43:44 Eric Miao napsal(a):
>> On Tue, Oct 27, 2009 at 6:59 AM, Ondrej Zajicek <santiago@crfreenet.org>
> wrote:
>> > Palm Tungsten C keyboard structure has swapped
>> > rows/cols gpio structures and does not work.
>> > This patch fixes it.
>> >
>> > Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
>>
>> This fix looks obvious to me. Applied to 'fix'.
>
> Just wondering ... you checked the GPIO directions, right ? I mean, it works in
> both directions, it just works worse the other one. I can't really check now.
>

It would be good if you can have it checked and give your Ack please.

> Also, it'll be possibly good to use the following emails for pxa patches:
> Eric Miao <eric.y.miao@gmail.com>
> Linux-ARM-Kernel <linux-arm-kernel@lists.infradead.org>
> Marek Vasut <marek.vasut@gmail.com>
>
> Those should be enough.
>
> Cheers!
