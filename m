Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZJ2Nwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZJ2Nwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZJ2Nwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:52:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:51293 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZJ2Nwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=E6r4E4x8fLcijdNqHZL2GtxE+Gc/SPpsC7WFKWuV9ugj3Vnl0kEJtLfiUgWHkS8ow6
         MYc4NcGjk94lQlNi1IxHU/lOE86IQPJ0O7wQnQk4gAoFWkAEPySmjzYMmTxkK0xqwwz4
         GyaycUdmXD5YX8OynmsNkha0d/wiNfI0RAYx8=
MIME-Version: 1.0
In-Reply-To: <200910291435.54203.bzolnier@gmail.com>
References: <200910291212.41656.bzolnier@gmail.com>
	 <200910291345.05888.bzolnier@gmail.com>
	 <20091029.055901.24976117.davem@davemloft.net>
	 <200910291435.54203.bzolnier@gmail.com>
Date: Thu, 29 Oct 2009 15:52:50 +0200
X-Google-Sender-Auth: ac5ce036b99a2b28
Message-ID: <84144f020910290652n2e75827dk698b238b6bd1cbed@mail.gmail.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Thu, Oct 29, 2009 at 3:35 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>> I'm saying that you should work with John to have him send a revert or
>> whatever to me.
>
> This is your responsibility to deal with your downstream maintainers,
> not mine and since you have accepted John's patch I'm asking you to
> revert rt2800pci patch from your tree.

So why don't you just send a patch to fix it up? I see you're doing
lots of cleanups to the staging drivers, why not direct some of that
energy to the drivers/net/wireless ones?

                         Pekka
