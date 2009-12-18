Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZLRTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZLRTk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLRTk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:40:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:48751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZLRTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:40:52 -0500
Message-ID: <4B2BDA6E.7000504@kernel.org>
Date: Fri, 18 Dec 2009 11:39:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86: check range in update range
References: <4B2B4C19.6010402@kernel.org>	<4B2B4F93.2080203@kernel.org> <20091218092323.2a648faf@jbarnes-piketon>
In-Reply-To: <20091218092323.2a648faf@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Fri, 18 Dec 2009 01:46:59 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> fend off wrong range
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> This could be merged with the previous patch.

yes, but first one just have moving and changing name etc.

YH

