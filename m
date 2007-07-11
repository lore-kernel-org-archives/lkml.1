Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbXGKTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbXGKTSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbXGKTSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:18:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbXGKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:18:04 -0400
Message-ID: <46952CC5.6050800@redhat.com>
Date: Wed, 11 Jul 2007 15:17:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>
In-Reply-To: <20070710160056.443ae9ae@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2007 10:00 AM, Alessandro Zummo wrote:
> 
>  Hello,
> 
>    with respect to commit e9e2cdb412412326c4827fc78ba27f410d837e6e 
>  and the thread at [1] I just wanted to let you all know that
>  the problem is still present :)
> 
>  I tried several combo of options, but only acpi=off or acpi=ht
>  will let the PC boot.
> 
>  I'm trying to debug it.. any help/pointers are appreciated. I dont't
>  have a deep knowledge of the subsystems involved.

What options did you try?

  nohpet
  nohz=off
  highres=off

Should be tried in various combinations.
