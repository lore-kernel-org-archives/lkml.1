Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXDKKAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXDKKAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXDKKAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:00:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:17751 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXDKKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JzZe+3BS9fPRENBb5OMRUWjvMOx4MarumxLIYcGMHPCv3qdeeX6g+Gn5F4oT7FZ+V/WZrEYMf4AslsNUn/een0JEEc/qmGdX8Ljgg35kPMVhW9UJTZPtXYm2rWhzyl28DQVnL4Bllz/N9wI89/WMyFxzyCk/npG4bjgg2RuUAFM=
Message-ID: <461CB1B1.9030207@gmail.com>
Date: Wed, 11 Apr 2007 19:00:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ahci.c: remove non-existing SB600 raid id
References: <5767b9100704110254s16566ce7n147aa578181d84e6@mail.gmail.com>
In-Reply-To: <5767b9100704110254s16566ce7n147aa578181d84e6@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
>    SB600 RAID and SB600 SATA is the same controller and share the
> same PCI ID 0x4380. There is such PCI ID 0x4381.

I assume 'no' is missing in the last sentence.  :-)

-- 
tejun
