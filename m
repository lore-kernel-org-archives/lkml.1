Return-Path: <linux-kernel-owner+w=401wt.eu-S1422883AbXDRLlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422883AbXDRLlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 07:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422887AbXDRLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 07:41:39 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:39491 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422883AbXDRLli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 07:41:38 -0400
Message-ID: <462603E0.3050208@free.fr>
Date: Wed, 18 Apr 2007 13:41:20 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux.kernel@free.fr
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de>
In-Reply-To: <p73odlo55q2.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> There are usually chipset specific bits that can be set to disable
> SMMs. See the datasheet if you can get them. Unfortunately most
> chipset vendors don't give out data sheets easily.

I managed to find the south bridge data sheet.

http://linux.kernel.free.fr/VT82C686B.pdf

(I'm still looking for the north bridge data sheet.)

Could someone point me in the right direction?

Regards.
