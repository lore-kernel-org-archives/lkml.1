Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbYBVQkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbYBVQkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBVQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:39:54 -0500
Received: from gw.goop.org ([64.81.55.164]:40115 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYBVQjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:39:53 -0500
Message-ID: <47BEFA4C.6030400@goop.org>
Date: Fri, 22 Feb 2008 08:37:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] let XEN depend on PAE
References: <47BEAB48.7050900@nets.rwth-aachen.de>
In-Reply-To: <47BEAB48.7050900@nets.rwth-aachen.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> As paravirtualized xen guests won't work with !X86_PAE, change the Kconfig
> accordingly.
>   

!PAE is supposed to work, but it is a rarely used configuration.  How 
does it fail?

    J
