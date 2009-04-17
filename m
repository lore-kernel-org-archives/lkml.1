Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZDQWQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZDQWQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZDQWQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:16:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbZDQWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:16:34 -0400
Message-ID: <49E8FF80.1020901@zytor.com>
Date: Fri, 17 Apr 2009 15:15:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Wait for console to become available, ver 3
References: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
>>  
> +	consoledelay=mS	[KNL] Wait up to mS milliseconds for the a preferred
> +			console to be registered, then continue. Useful for
> +			systems where a console may not be plugged in, such as
> +			for USB serial devices.
> +

Pet peeve:

The symbol for millisecond is "ms".  mS is a unit of conductance, 
millisiemens.

	-hpa
