Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbYHLFu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbYHLFu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHLFuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:50:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:58903 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYHLFuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mQIuuHSEawUfsrZBCVrelqk+0+p/nHNTl0ajcLQnXjVpus5YhM5PW3+iZ+prGwzecE
         wNOG1Fkd1da4LE1YPIFY1+2I6wk97/tglGzE/PtaPQAX0zYXf4/pPJ0XvbV0rHpe3wh0
         xaWLKZ4ZwFhl9oVrGk/Ah7pPORExTU0rDznqY=
Message-ID: <8db1092f0808112250y6b52a4ben879d83deda6496ce@mail.gmail.com>
Date: Tue, 12 Aug 2008 07:50:09 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, hancockr@shaw.ca
In-Reply-To: <20080811210140.GW9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <20080811202731.GB2916@elte.hu>
	 <20080811210140.GW9038@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/11 Andi Kleen <andi@firstfloor.org>:
[...]
>
> You can verify this by booting with pci=nommconf. If it works
> then it's likely that.
>
[...]

It doesn't help
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
