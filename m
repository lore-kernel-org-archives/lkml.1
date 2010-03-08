Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab0CHWcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:32:07 -0500
Received: from claw.goop.org ([74.207.240.146]:40603 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab0CHWcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:32:05 -0500
Message-ID: <4B957AD9.2030705@goop.org>
Date: Mon, 08 Mar 2010 14:31:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/7] xen: Make event channel work with PV
 extension of HVM
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-6-git-send-email-sheng@linux.intel.com> <4B8C6C0D.3070005@goop.org> <201003041337.26229.sheng@linux.intel.com> <alpine.DEB.2.00.1003041155590.24752@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003041155590.24752@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 03:58 AM, Stefano Stabellini wrote:
> Jeremy, can we have our own temporary branch so that we can work
> together on a common code base to finish this patch series?
>    

I'm not sure quite what you mean, but I've committed Sheng's work to 
xen/pvhvm-sheng for now, and I'll commit your patches to a similar 
branch once I know where to apply them.

     J
