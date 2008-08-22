Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbYHVI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbYHVI6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYHVI61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:58:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:52425 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYHVI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vv68QdWgTSB/i40LzgyP4bAN9MdD/ZjKNzJ9rpfULrlQ7x71wH9/nKI6OQ7G5d8MBV
         wDiCY8tIQ5EOrf9O2ZYLVNZvKvBaUHR1fYUoqevFw1ObVlUiIjL3nu/cYkUuEaqI3Rdp
         NAsXcRN0S2aMYIsHzPmIB93yZ6sWjdSFYYYrA=
Message-ID: <8db1092f0808220158k742c6429y5f8ee48d5eb61a30@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:58:25 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <200808211445.46467.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <8db1092f0808160236o63c42de4k3c455c349d3e9da6@mail.gmail.com>
	 <8db1092f0808201136y15a67647i95fd00fb5d2476fc@mail.gmail.com>
	 <200808211445.46467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/21 Rafael J. Wysocki <rjw@sisk.pl>:

>
> Do you have a log where it doesn't hang?
>
> Rafael
>

http://unixy.pl/maciek/download/kernel/2.6.27-rc3/dmesg-2.6.27-rc3.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
