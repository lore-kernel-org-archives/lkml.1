Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZFYPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZFYPxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZFYPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:53:05 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46521 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZFYPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OIGcuSGhcP5TM0reOV1NZSRMEwch69u9rTgPbeMs/ZuCFpAIKmqWvXtf9A+SIKRxjw
         LcEcnwKTNX64vCAj+8F63YFr4GcbHpsa9t2YlUloHGbkp4/q1yFP1ELNc1bP5HOrMMAs
         Jq19P47E18ox7gj165mcje4AIuZDwNiW7mypM=
MIME-Version: 1.0
In-Reply-To: <4A41C4E2.5080206@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com> <4A417176.40008@jp.fujitsu.com>
	 <4A41C4E2.5080206@linux.intel.com>
Date: Thu, 25 Jun 2009 17:53:03 +0200
Message-ID: <8db1092f0906250853g7aa1af09w678b700780eabcd3@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/24 Andi Kleen <ak@linux.intel.com>:
> Hidetoshi Seto wrote:
>>
>> Peter, could you put this patch into urgent too?
>
> Acked-by: Andi Kleen <ak@linux.intel.com> too
>
> (BTW that is needed in interaction with the new timer migration code
> that was merged into .31; .30 based kernels don't need it)
>
> -Andi
>
>

Are this patches was added to -rc1?

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
