Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0BMISb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:18:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab0BMISa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:18:30 -0500
Message-ID: <4B765F5D.9070106@zytor.com>
Date: Sat, 13 Feb 2010 00:14:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Jean Delvare <khali@linux-fr.org>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	 <20100212150137.648dca7c@hyperion.delvare>	 <4B75A5FE.8020408@zytor.com> <12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>
In-Reply-To: <12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 11:42 PM, Tony Luck wrote:
> 
> 3) Keep all the .gz and .bz2 in the old 2.x hierarchy
> 4) Only have .xz in the new 3.x directories.
> 

I really dislike this for reasons already stated.  Keep in mind that the
compression management is global to the entire archive, not just to the
kernel, too.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

