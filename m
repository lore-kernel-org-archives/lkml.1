Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYIJJN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYIJJN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYIJJNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:13:19 -0400
Received: from www.tglx.de ([62.245.132.106]:52154 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYIJJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:13:19 -0400
Date: Wed, 10 Sep 2008 11:12:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: warn_on regression after 2.6.27-rc5
In-Reply-To: <200809101008.40973.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.1.10.0809101111470.13819@apollo.tec.linutronix.de>
References: <200809101008.40973.borntraeger@de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008, Christian Borntraeger wrote:
> 
> While I agree with doubling the time, I am not sure if a WARN_ON is 
> appropriate. After all the code is able to fix the timer setting.

The WARN_ON is removed already. It was there temporary to gather
information, which worked :)

Thanks,

	tglx
