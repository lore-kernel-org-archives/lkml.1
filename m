Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369Ab0AFFOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0AFFOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 00:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164Ab0AFFOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 00:14:40 -0500
Received: from claw.goop.org ([74.207.240.146]:45557 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab0AFFOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 00:14:39 -0500
Message-ID: <4B441C30.7020108@goop.org>
Date: Wed, 06 Jan 2010 16:14:24 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001051942440.3483@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.1001051942440.3483@bogon.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 02:48 PM, Christian Kujau wrote:
>>> The Dom0 is running a 2.6.24-24-xen Ubuntu kernel amd I'm kinda reluctant
>>> to upgrade, as I don't have a serial console to this MacMini, if things go
>>>        
> Just out of curiosity: will this be an issue in the near future? I'm
> trying to follow kernel development in my DomU, but can't upgrade Dom0 for
> quite a while, so kernel versions (DomU vs Dom0) will diverge more and
> more.
>    

No.  New domU on old dom0 or vice-versa should work indefinitely.  If 
not, report it as a bug.

     J
