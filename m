Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZDRFlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZDRFlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 01:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZDRFlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 01:41:14 -0400
Received: from smtpauth.net4india.com ([202.71.129.139]:40575 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751114AbZDRFlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 01:41:13 -0400
Message-ID: <49E967E7.5070800@xenontk.org>
Date: Sat, 18 Apr 2009 11:10:55 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2 ThunderBrowse/3.2.4
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: X freezes intermittently with 2.6.29.1
References: <49E6D8FE.80908@xenontk.org> <86802c440904160018j5c4842d8t92742b6a1b2e4514@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC46587A0784@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46587A0784@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2009 11:08 PM, Pallipadi, Venkatesh wrote:
> 
> Specifically the patch here will help (not sure whether it cleanly applies over 29.1.
> 
> http://marc.info/?l=linux-kernel&m=123923026401648&w=2
> 
> Thanks,
> Venki
>  


Thanks Venkatesh, that patch fixes the problem. This should be submitted
to -stable as I know at least one other person who has
this regression and the latest Fedora kernels have the problem as well.

Regards,
David.
