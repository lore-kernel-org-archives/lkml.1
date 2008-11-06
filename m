Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYKFW3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYKFW3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYKFW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:29:06 -0500
Received: from gw.goop.org ([64.81.55.164]:60308 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYKFW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:29:05 -0500
Message-ID: <49136FAE.6070308@goop.org>
Date: Thu, 06 Nov 2008 14:29:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu> <49136168.3040604@goop.org> <20081106213344.GF24579@elte.hu> <49136628.1020000@goop.org> <20081106222039.GA7505@elte.hu>
In-Reply-To: <20081106222039.GA7505@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ah! asm-generic was missed by my grep. (and i suspect Jan missed it 
> too)
>   

cscope is your friend.

>> Subject: xen: fix use of pgd_page now that it really does return a page
>>     
>
> applied to tip/x86/urgent, thanks!
>   

Thanks,
    J
