Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0BMKYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:24:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36778 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0BMKYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:24:48 -0500
Message-ID: <4B767DD4.6090800@cs.helsinki.fi>
Date: Sat, 13 Feb 2010 12:24:20 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [0/4] Update slab memory hotplug series
References: <20100211953.850854588@firstfloor.org>
In-Reply-To: <20100211953.850854588@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Should address all earlier comments (except for the funny cpuset
> case which I chose to declare a don't do that)
> 
> Also this time hopefully without missing patches.
> 
> There are still some other issues with memory hotadd, but that's the 
> current slab set.
> 
> The patches are against 2.6.32, but apply to mainline I believe.

The series has been applied and will appear in the next version of 
linux-next.
