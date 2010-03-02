Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0CBBcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:32:22 -0500
Received: from claw.goop.org ([74.207.240.146]:59953 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0CBBcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:32:21 -0500
Message-ID: <4B8C6AA4.8000700@goop.org>
Date: Mon, 01 Mar 2010 17:32:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for
 Xen
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <4B8C5ED9.1040109@goop.org> <201003020926.03512.sheng@linux.intel.com>
In-Reply-To: <201003020926.03512.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 05:26 PM, Sheng Yang wrote:
>> Why 2.6.33?  I'm currently working on 2.6.32; I intend to move to .33
>> shortly, but .32 is a much more convenient base (particularly if you're
>> interested in getting these changes into any distro kernels).
>>
>> I rebased it to .32 without much effort.
>>      
> OK.
>    

Hm, looks like the x86_platform_ipi stuff is missing in .32.

     J
