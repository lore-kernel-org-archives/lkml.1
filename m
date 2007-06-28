Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbXF1NWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbXF1NWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXF1NW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:22:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:33529 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXF1NW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=OH6aX7U5XaEzRdN6nozlmhctG89NOgsDtnneYUkDA5L8GqQVkFaIEzLXrVX5U6fl6JtER0+aPY969x9In0p7G78nN0PGMCQ+V//PfjG3AqLe2mRt2U630n3e610G9Yo/f0WV3WCga1kiorFaw9CrLEOcmp8/KjOeRR+hJ1Mnl0c=
Message-ID: <4683B5FE.9020703@gmail.com>
Date: Thu, 28 Jun 2007 18:52:06 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: speedstep-centrino (no such device)
References: <4683AAA3.9060607@mandic.com.br>
In-Reply-To: <4683AAA3.9060607@mandic.com.br>
X-Enigmail-Version: 0.95.1
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renato S. Yamane wrote:
> Hi,
> 
> Is impossible use speedstep in my Laptop with Pentium M 1,86Ghz:
> 
> #modprobe speedstep-centrino
> FATAL: Error inserting speedstep_centrino
> (/lib/modules/2.6.18-3-686/kernel/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.ko):
> No such device
> 
> To do that (speedstep), I need install powersaved, but
> speedstep-centrino is not used.
> 
> More information can see in:
> <https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/66812>
> 
> Regards,
> Renato

did you try with the latest kernel (it works on my PentiumM and kubuntu)
or is this a ubuntu specific bug?


-jb
-- 
Tact is the art of making a point without making an enemy.
