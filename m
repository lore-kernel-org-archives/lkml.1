Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0CJOcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:32:04 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44611 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0CJOb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TlhtokvINSaH+pPwTJW5Th9T9AikMs5vVxuSXdkftkcRj2NtQ6xxYV+f2WesZGlbJH
         MIdc/vGqqK2IVr+1XVjHz+01UuO/dvjiwvNtD8zGwxikT1f+rAn23Ah/m894pL/t9Roj
         ELhhwW+6qJnHRyaYM9CR/B1DFNOYEKaAO2Jc4=
Message-ID: <4B97AD5B.5080802@garzik.org>
Date: Wed, 10 Mar 2010 09:31:55 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ata1 timeouts on 2.6.34-rc1
References: <40a4ed591003100208v67b61ca5sd7a3ab8da99e975e@mail.gmail.com>
In-Reply-To: <40a4ed591003100208v67b61ca5sd7a3ab8da99e975e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 05:08 AM, Zeno Davatz wrote:
> I am also on an Intel SSD (160 GB). Every timeout blocks my PC for some seconds.


PLEASE provide full information standard to any bug report.  Just 
posting that you have a timeout tells us nothing about the hardware 
involved.

lspci and full dmesg output is needed, at a minimum.

	Jeff



