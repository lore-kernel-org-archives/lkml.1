Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXLEMHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXLEMHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXLEMHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:07:23 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:52881 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbXLEMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:07:22 -0500
Message-ID: <47569476.1010302@grupopie.com>
Date: Wed, 05 Dec 2007 12:07:18 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
References: <4755BA14.8060706@grupopie.com> <20071204211410.GA5995@Krystal>
In-Reply-To: <20071204211410.GA5995@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Paulo Marques (pmarques@grupopie.com) wrote:
>> When resolving symbol names from addresses with aliased symbol names, 
>> kallsyms_lookup always returns the first symbol, even if it is a weak 
>> symbol.
>>
>> [...]
>> From: Paulo Marques <pmarques@grupopie.com>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Please wait for me to accept the changes before adding signed-off-by.

My mistake was that I didn't realized you'd already corrected the 
original patch when you posted this:

http://lkml.org/lkml/2007/11/13/292

Since I thought it was the same patch, it already had your 
"Signed-off-by". Sorry for the confusion... :(

-- 
Paulo Marques - www.grupopie.com

"I haven't lost my mind -- it's backed up on tape somewhere."
