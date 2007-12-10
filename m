Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbXLJM6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbXLJM6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXLJM5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:57:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:57196 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXLJM5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:57:52 -0500
Message-ID: <475D37CE.8040602@qumranet.com>
Date: Mon, 10 Dec 2007 14:57:50 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at>
In-Reply-To: <20071210112135.GA19783@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining wrote:
> On Mo, 10 Dez 2007, preining wrote:
>   
>> I was running a kvm installing windows, and eek it crashed happily my
>> computer, probably because I forgot to give kvm -no-acpi option.
>>     
>
> I forgot:
>
> kernel 2.6.24-rc4
> kvm  55 (debian sid 55+dfsg-1)
>   

Is the kvm kernel module pure 2.6.24-rc1, or are you running the kernel 
module provided by kvm-55?

-- 
error compiling committee.c: too many arguments to function

