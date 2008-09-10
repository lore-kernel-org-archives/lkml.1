Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYIJIl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYIJIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIJIlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:41:20 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52257 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYIJIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:41:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: warn_on regression after 2.6.27-rc5
Date: Wed, 10 Sep 2008 10:41:07 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809101008.40973.borntraeger@de.ibm.com>
In-Reply-To: <200809101008.40973.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101041.07737.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. September 2008 schrieb Christian Borntraeger:
> Hello Thomas,
> 
> this commit 
> 
> commit 1fb9b7d29d8e85ba3196eaa7ab871bf76fc98d36
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Sep 3 21:37:14 2008 +0000
> 
>     clockevents: prevent endless loop lockup
> 
> 
> causes the following warning on my Thinkpad T61p:

Ok, forget it. I just found the mail thread and the patch in my last git 
update.

Thanks

Christian
