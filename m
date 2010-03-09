Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0CIT0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:26:22 -0500
Received: from claw.goop.org ([74.207.240.146]:33373 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0CIT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:26:18 -0500
Message-ID: <4B96A0D4.60605@goop.org>
Date: Tue, 09 Mar 2010 11:26:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Sheng Yang <sheng@linux.intel.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com>  <1268032732-8025-8-git-send-email-sheng@linux.intel.com>  <alpine.DEB.2.00.1003081701160.16237@kaball-desktop>  <201003090953.16985.sheng@linux.intel.com>  <4B95F224.3060205@goop.org> <1268128085.11737.59761.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1003090954010.4869@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003090954010.4869@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 02:22 AM, Stefano Stabellini wrote:
> Indeed.
> You just need the pirq mappings and few other things, it shouldn't be
> too hard.
> At this point I am going to do that myself after this patch series is
> completed.
>    

Thanks.  You might want to coordinate with Konrad who's doing the same 
thing to get pcifront into an upstreamable form; I think there would be 
some overlap.

     J
