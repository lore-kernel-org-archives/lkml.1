Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYC0MKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYC0MKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbYC0MKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:10:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:27058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbYC0MKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JDPA0RWdkyYxfxA/PpOMp/PMgRxF5P4vcX8POFeSjQ5kwYVgDdq/GOtk4dGCiemcpidoK+rwbvNsbx+XRb1zwPG8e+vkssXz5i873e6uKKmGAdCDHfrGcofrcBi5AZtAsBvQfeoyhJ0WQbWo/N8rgOSQHQlCzYVjei1dqsSQWh4=
Message-ID: <47EB8EAA.7030501@gmail.com>
Date: Thu, 27 Mar 2008 13:10:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, wim@iguana.be
Subject: Re: [PATCH 1/1] Blackfin char driver for Blackfin on-chip OTP memory
 (v3)
References: <1206643758-9319-1-git-send-email-cooloney@kernel.org>	 <47EB8050.4010700@gmail.com> <8bd0f97a0803270509k7620e938ldec13f2f260aef5a@mail.gmail.com>
In-Reply-To: <8bd0f97a0803270509k7620e938ldec13f2f260aef5a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger napsal(a):
> On Thu, Mar 27, 2008 at 7:09 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>  Will somebody pick the patch up (otherwise cc akpm or I might fwd it)?
> 
> not sure what you mean.  Bryan posts the patches for review, and then
> any of the Blackfin-specific ones that dont have a subsystem get into
> mainline via git pull requests from the Blackfin repo ...

Yes, that answers my question, thanks,
