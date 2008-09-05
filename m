Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYIEFKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYIEFKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYIEFJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:09:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYIEFJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:09:54 -0400
Message-ID: <48C0BEEA.8040500@cn.fujitsu.com>
Date: Fri, 05 Sep 2008 13:08:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       jh@sgi.com
Subject: Re: [PATCH] cpuset: hotplug documentation fix
References: <48C0AAF8.605@cn.fujitsu.com> <20080904232958.6ac79ada.pj@sgi.com>
In-Reply-To: <20080904232958.6ac79ada.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Thanks for updating this, Li Zefan.
> 
> I would suggest one minor wording fix.  The past tense of bind is bound.
> (Don't you just love how regular the English language is ;)?
> 

wiki:

binded

   1. (nonstandard) Bound; simple past tense and past participle of bind.

google binded gave me 405,000 items. :)

I'll fix it and resend the patch

> So, replace:
>   +cpuset is binded with another cgroup subsystem which has some restrictions
> with:
>   +cpuset is bound with another cgroup subsystem which has some restrictions
> 
> Either way:
> 
> Acked-by: Paul Jackson <pj@sgi.com>
> 

