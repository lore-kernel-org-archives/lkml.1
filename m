Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472Ab0A0O7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0A0O7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692Ab0A0O73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:59:29 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:45429 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0A0O73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:59:29 -0500
Message-ID: <4B6054DA.7090503@xenontk.org>
Date: Wed, 27 Jan 2010 20:29:38 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: ykzhao <yakui.zhao@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fix For Korg Bug #14897 (GM45 Display Flicker)
References: <4B60080E.2000508@xenontk.org> <1264600328.10341.29.camel@localhost.localdomain>
In-Reply-To: <1264600328.10341.29.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 07:22 PM, ykzhao wrote:
> 
> Hi, David
> 	Very good work. Thanks for looking at this issue.
> 	Do you have an opportunity to try the following patch set on 2.6.33-rc5
> kernel and see whether the display flicker issue can be fixed?
> 
>> http://lists.freedesktop.org/archives/intel-gfx/2010-January/005505.html	
> 
> (The first patch can be skipped as it is already in 2.6.33-rc5 kernel).
> 
> Thanks.
> 	Yakui
> 

Hi Yakui,

Your patchset (specifically patch #8) also fixes the problem.

Can this be merged for 2.6.33?

Thanks,
David.
