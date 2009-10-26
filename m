Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZJZSme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZJZSme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZJZSmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:42:33 -0400
Received: from icculus.org ([67.106.77.212]:38860 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZJZSmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:42:33 -0400
Message-ID: <4AE5ED98.8090500@icculus.org>
Date: Mon, 26 Oct 2009 14:42:32 -0400
From: "Ryan C. Gordon" <icculus@icculus.org>
Organization: icculus.org
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Rayson Ho <raysonlogin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FatELF & patents
References: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>	 <4AE5C7C0.3060305@mayc.ru> <73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
In-Reply-To: <73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> However, there are 20 claims in the patent. Just using a different way
> to store the architecture independent header might not be enough.

I'm not a lawyer, so I don't have anything to add to this except that 
FatELF has a few fields that Apple's format doesn't, so the flow chart 
they specify isn't the same. I don't really know enough about how 
patents work.

Any lawyers around that can comment on this? Is this something to be 
concerned with (and if so, what sort of changes would make FatELF not 
violate the patent), or is this all just business as usual?

--ryan.


