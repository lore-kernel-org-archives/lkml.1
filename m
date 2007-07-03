Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXGCIZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXGCIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXGCIZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:25:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:36069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbXGCIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dApVTVn75ny6ctgtOl7+EYT7G66vwV3hQIu5vIYlM2kLkUqT+Q/HxU8foThj09UyvstVKBW8dfUwBYNao/H/nbd70vnY/vHDl8OUt7oT+wbAOcraEgYfOKYGdJGZJ0D0qYu0UAtRpe0a6/ZFEkojC6yBeMmalmXH9IFYWNXzbF8=
Message-ID: <468A07A0.5010302@gmail.com>
Date: Tue, 03 Jul 2007 17:24:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Dan <metalifloyd@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: PROBLEM: SATA AHCI driver significant throughput loss in 2.6.22-rc5-g75154f40-dirty
References: <439fa30706262117u2d5553dfp8395c6ca41574a8c@mail.gmail.com> <6bffcb0e0706290636t334e2e29h17d215cee77dc2da@mail.gmail.com>
In-Reply-To: <6bffcb0e0706290636t334e2e29h17d215cee77dc2da@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi,
> 
> [adding linux-ide to cc]
> 
> On 27/06/07, Dan <metalifloyd@gmail.com> wrote:
>> Something changed with the AHCI SATA driver in the latest git version.
>> With 2.6.21 I get ~49MB/sec according to hdparm. Using the latest git
>> version I only get ~8MB/sec. I've attached my .config and have
>> included some info about my system below. Please let me know if you
>> need more information or if I can help test anything.

Please post boot dmesgs of before and after.

-- 
tejun
