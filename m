Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZETJmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZETJmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZETJm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:42:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38808 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZETJmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:42:25 -0400
Message-ID: <4A13D045.6090905@jp.fujitsu.com>
Date: Wed, 20 May 2009 18:41:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] [MCE] Updated 32bit merge for tip x86 mce2 branch
References: <20090519215631.GA15626@basil.nowhere.org>
In-Reply-To: <20090519215631.GA15626@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I also reverted one patch where the patch author agreed it should
> be reverted.

>       Revert "x86, mce: Add mce=nopoll option to disable timer polling"

That is:

> commit 41e654ade96b57c2dca4cea3e21f75819ab9696c
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Wed Apr 29 10:17:01 2009 +0200
> 
>     Revert "x86, mce: Add mce=nopoll option to disable timer polling"
> 
>     This reverts commit f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95.
> 
>     Seto-san has an updated patch following recent discussion that
>     should be used instead.

OK.  Please use following patches with my Signed-off-by instead.
And an another revert patch should be applied to tip tree too.


Thanks,
H.Seto

