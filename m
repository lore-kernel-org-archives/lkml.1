Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbXLFUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbXLFUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLFUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:39:10 -0500
Received: from mail.tmr.com ([64.65.253.246]:43901 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXLFUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:39:10 -0500
Message-ID: <475861D4.20909@tmr.com>
Date: Thu, 06 Dec 2007 15:55:48 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Brett Warden <brett.warden@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] bw-qcam: adds parameter aggressive to skip passive detection
 and directly attempt initialization
References: <20071205173756.0cd80e85@the-village.bc.nu> <a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com>
In-Reply-To: <a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brett Warden wrote:
> On Dec 5, 2007 9:37 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> Although I would suggest that "aggressive" may not be the best term - I'm
>> not such of a good one however - skip_passive ?
> 
> How about force_init?
> 
Much more descriptive.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
