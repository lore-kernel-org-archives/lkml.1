Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0CJTpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:45:51 -0500
Received: from claw.goop.org ([74.207.240.146]:45738 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab0CJTpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:45:50 -0500
Message-ID: <4B97F6EB.9010505@goop.org>
Date: Wed, 10 Mar 2010 11:45:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>	<20100310173339.GO1878@reaktio.net> <alpine.DEB.2.00.1003101739480.28412@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003101739480.28412@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 09:55 AM, Stefano Stabellini wrote:
> However it might be still possible to provide an additional, backward
> compatible, delivery mechanism in case the new one fails.
> I'll try to explore this option.
>    

Yes, please.  A lot of the interest in pv drivers for hvm comes from 
people running long-deployed Xen systems based on RHEL, etc.

     J
