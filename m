Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZLSAfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZLSAfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZLSAfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:35:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZLSAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:35:22 -0500
Message-ID: <4B2C1F8D.5070500@zytor.com>
Date: Fri, 18 Dec 2009 16:34:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org> <4B2BE1BF.60803@zytor.com> <4B2BE348.207@kernel.org> <4B2BF38F.3090101@zytor.com> <4B2C14A3.90906@kernel.org> <4B2C1D69.8090703@zytor.com> <4B2C1DFF.7090405@kernel.org>
In-Reply-To: <4B2C1DFF.7090405@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 04:27 PM, Yinghai Lu wrote:
> 
> can you put current 9 patches into tip? i will submit following patch that merge range and early_res
> 

I still have to review them (I had to spend the day deal with non-kernel
job duties that had been old hold for the merge window.)  I will look at
it probably Monday or Tuesday.

Sorry,

	-hpa
