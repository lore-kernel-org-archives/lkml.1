Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0BJDLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:11:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0BJDLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:11:53 -0500
Message-ID: <4B7221EF.4000508@zytor.com>
Date: Tue, 09 Feb 2010 19:03:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, apic: Don't use logical-flat mode when
 CPU hotplug may exceed 8 CPUs
References: <20100118201256.672679042@sbs-t61.sc.intel.com>	 <tip-418f727639cfc8f03068aae09f473c493c759b9b@git.kernel.org>	 <4B71ADB3.5010303@kernel.org> <1265767304.2833.19.camel@sbs-t61.sc.intel.com> <4B721965.2030108@kernel.org> <4B722133.8080801@kernel.org>
In-Reply-To: <4B722133.8080801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 07:00 PM, Yinghai Lu wrote:
> 
> other subarch setup_apic_routing is just pr_info...
> 
> so your patch should be ok.
> 

Great, can I take that as an Acked-by: or Reviewed-by: from you?

I really appreciate the review.

	-hpa

