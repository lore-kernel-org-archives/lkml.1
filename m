Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZAWHid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZAWHid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 02:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZAWHi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 02:38:26 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:8670 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZAWHiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:38:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hhG9dtOZDq40Eln+brMJkE6JlXFIT95BigzvDAwmv/ncMPHPyY0SRkCeT3cOjHT/6P
         DsiWdYUS6wF44fcVZZngsIEJnuNq9F9sI0jq658gRxYuLEu9VEgM+arUN4X0eHYxZ/gc
         iymi3goZx1VEcjNjyugxFons5MmoIIx+jzMIk=
MIME-Version: 1.0
In-Reply-To: <m3k58nicjh.fsf@intrepid.localdomain>
References: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
	 <m3k58nicjh.fsf@intrepid.localdomain>
Date: Fri, 23 Jan 2009 08:38:24 +0100
Message-ID: <b0438a630901222338s3fe28651v8e0bdad1246b6011@mail.gmail.com>
Subject: Re: IXP4XX queues
From: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Karl Hiramoto <karl@hiramoto.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2009/1/22 Krzysztof Halasa <khc@pm.waw.pl>:
> Miguel Ángel Álvarez <gotzoncabanes@gmail.com> writes:
>
>> Last December we talked about 64 queues and IXP4XX. Karl has a patch
>> for them, and although I think it could be better to splitt it into
>> two different ones ("plain 64 queue expansion" for which I proposed a
>> modified patch based on Karl's, and "debugging and other things"), I
>> prefer Karl's to none.
>
> I will look at this stuff again soon, currently -ENOTIME but this
> condition will only last for few days. Thanks for the reminder.

Sure... I was just offering my help.

Miguel Ángel Álvarez
