Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZCNUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZCNUp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZCNUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:45:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZCNUpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:45:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LG2bDxc1DwUK5oekJJMx2Ykp75yORSD0KGtwdGaeCezZKN9u6VDAflnP4wAeNwavH
	KejU2i5zy+RZ1Nbj0NSOw==
MIME-Version: 1.0
In-Reply-To: <200903142051.57971.bzolnier@gmail.com>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
	 <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
	 <da824cf30903140012g1565696kd6c69b4cd513f15b@mail.gmail.com>
	 <200903142051.57971.bzolnier@gmail.com>
Date: Sat, 14 Mar 2009 21:45:38 +0100
Message-ID: <da824cf30903141345l55f51571u92e0d5787aa61d7d@mail.gmail.com>
Subject: Re: [PATCH 03/10] ide: destroy DMA mappings after ending DMA
From: Grant Grundler <grundler@google.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 8:51 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
...
>> I can create separate patches for both. Which git tree should I base
>> them against?
>
> linux-next git tree
> (or pata-2.6 quilt tree)

I've not used quilt yet and can only deal with git in a very crude way.
Thanks for the references!

....
> Seems so but please cc: scc_pata & tx4939 maintainers on your patch.

Yes, will do!

thanks,
grant
