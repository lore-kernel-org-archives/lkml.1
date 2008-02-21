Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbYBUCv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbYBUCv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYBUCvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:51:19 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:51449 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYBUCvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=G5yZh5taA8VogfKfyjLmGjmYKnHaJ6od0Gu4lbZcssvwrKM6VhEQLF26jsRl1X9J/NkcEqI9YuVcUm0GvES9jw2W3q9Q7p48up3i96tdPmkhLkkoqqXDPY4OXQKON/MyUThBiEUdnoOJk4xSPEc6uBYz4mqQ7J2qzS4MdkPdtoo=
Message-ID: <47BCE71F.2000309@gmail.com>
Date: Thu, 21 Feb 2008 11:51:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
References: <20080214184700.0bd3837d@highlander.home.lan>	<47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan>
In-Reply-To: <20080215191215.430ee2e0@highlander.home.lan>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malte Schröder wrote:
>> Does irqpoll kernel parameter help?
>  
> No, problem stays.

Can you capture full boot log w/ irqpoll specified?  If you have root
filesystem connected to ahci, you'll probably have to use serial or
netconsole.  Also, please post full boot log from 2.6.23.11.

Thanks.

-- 
tejun
