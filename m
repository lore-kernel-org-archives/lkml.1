Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZIRMNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZIRMNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZIRMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:13:31 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:44721 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbZIRMN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520909180506n667b161esca739811d8604d49@mail.gmail.com>
References: <778490.95843.qm@web50204.mail.re2.yahoo.com> <9b2b86520909180506n667b161esca739811d8604d49@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 14:13:18 +0200
Message-ID: <ac3eb2510909180513i188bcb96t15b3b299fa97c2ba@mail.gmail.com>
Subject: Re: Auto loading of kernel modules COLD/HOT BOOT
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: vprabu vprabu <prabu_online2005@yahoo.com>, linux-hotplug@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
       kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 14:06, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 9/18/09, vprabu vprabu <prabu_online2005@yahoo.com> wrote:
>> I am new to kernel hacking ; i had been an application guy; now focusing
>> into the fundamentals of linux kernel. I really have little knowledge about
>> the kernel, modules and auto loading of modules.After a lot of googling ,i
>> am now much perplexed :-).
>>
>>  Most of the articles are contradictory to each
>> other and not very clear ( or not so simple at my level to comprehend)
>
> Heh, I think that's a common reaction.  I don't know where there is a
> good introduction.

Here is a pretty old text from 2005, it explains some bits, if the old
stuff before udev is known to the reader. Some things have changed in
the meantime, like the event queue stuff which is no longer directly
accessible, but the general picture is still pretty close to what we
do today:
  http://vrfy.org/log/recent-state-of-udev.html

Kay
