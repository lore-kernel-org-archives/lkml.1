Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYHVKHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYHVKHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYHVKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:07:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYHVKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:07:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Date: Fri, 22 Aug 2008 12:10:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com> <200808211445.46467.rjw@sisk.pl> <8db1092f0808220158k742c6429y5f8ee48d5eb61a30@mail.gmail.com>
In-Reply-To: <8db1092f0808220158k742c6429y5f8ee48d5eb61a30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221210.59560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Maciej Rutecki wrote:
> 2008/8/21 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> >
> > Do you have a log where it doesn't hang?
> >
> > Rafael
> >
> 
> http://unixy.pl/maciek/download/kernel/2.6.27-rc3/dmesg-2.6.27-rc3.txt

This doesn't look like the same configuration as in the picture you
sent previously.  In particular, the ICH7 lines are missing.

Thanks,
Rafael
