Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXICTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXICTy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXICTyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:54:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXICTys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lg0EOI6HehnPJD0oMEooK7RpPYJ2kk0CHXsTXbySE1Q6bHNXQ+6M/jZ76L3x8sEuykBPlz4A2UK+mYeYNemSZ9ZcVAXUUy/ujIYcAEz3q30uEqmXhQOUbbJ7u37E0JtxLvbrLvWRSYsYQN35Umc+ucUq6UaCvogZBwM8ycPrBLc=
Message-ID: <46DC6682.7070400@gmail.com>
Date: Mon, 03 Sep 2007 21:54:42 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com> <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com> <20070902114032.7dbfb21a@the-village.bc.nu> <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt ha scritto:
> On Sep 2 2007 11:40, Alan Cox wrote:
>   
>>> i've been out for a week, but found no notice, did i lost any email or
>>> no activity on this issue?
>>>       
>> I tagged it onto the obscure IDE report pile. It doesn't contain any
>> really useful information and its probably not an IDE layer bug as of
>> itself. But its on the todo list for further investigation and to see if
>> patterns emerge
>>     
>
> I shall give this a spin too, since I happen to have sis5513.
>
>   

oops i just noticed i made a typo in the subject...5513 for me too

Patrizio
