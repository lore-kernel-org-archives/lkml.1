Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0BNFrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 00:47:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34047 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab0BNFrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 00:47:41 -0500
Message-ID: <4B778D86.5020007@zytor.com>
Date: Sat, 13 Feb 2010 21:43:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Tony Luck <tony.luck@intel.com>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<4B75A5FE.8020408@zytor.com>	<12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>	<4B765F5D.9070106@zytor.com> <20100213095352.361702d0@hyperion.delvare>
In-Reply-To: <20100213095352.361702d0@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 12:53 AM, Jean Delvare wrote:
>>
>> I really dislike this for reasons already stated.  Keep in mind that the
>> compression management is global to the entire archive, not just to the
>> kernel, too.
>
> How hard a requirement is this? It might be the right time to
> reconsider... Tony's plan may not be perfect but overall I think I like
> it.
>

It's pretty darn hard.  It makes it particularly messy for the mirrors 
to ignore it.

	-hpa
