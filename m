Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXF0O0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXF0O0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXF0OZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:25:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbXF0OZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:25:53 -0400
Message-ID: <46827268.4030104@zytor.com>
Date: Wed, 27 Jun 2007 10:21:28 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: Problems with fb console [was Re: 2.6.12-rc4-mm2]
References: <20050516021302.13bd285a.akpm@osdl.org>	<20070627023527.5e643e32@werewolf-wl> <20070626175433.dceee930.akpm@linux-foundation.org>
In-Reply-To: <20070626175433.dceee930.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> I have a (stupid, I suppose) problem with framebuffer console.
>> I have builtin VESAFB in this kernel, so:
>>
>> werewolf:/boot# grep _FB config-2.6.21-jam09 | grep =y
                                          ^^^^^^

Is this actually the -mm kernel?  And if so, does it work in earlier 
kernels?

	-hpa
