Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYE1Vdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYE1Vdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYE1Vdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:33:36 -0400
Received: from gw.goop.org ([64.81.55.164]:43011 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbYE1Vdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:33:35 -0400
Message-ID: <483DCF8C.80700@goop.org>
Date: Wed, 28 May 2008 22:33:00 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-next@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-next 20080528: XEN build error when no Power Mgt enabled
References: <20080528143817.d639123b.randy.dunlap@oracle.com>
In-Reply-To: <20080528143817.d639123b.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> linux-next-20080528/drivers/xen/manage.c: In function 'xen_suspend':
> linux-next-20080528/drivers/xen/manage.c:43: error: implicit declaration of function 'device_power_down'
> linux-next-20080528/drivers/xen/manage.c:65: error: implicit declaration of function 'device_power_up'
> linux-next-20080528/drivers/xen/manage.c: In function 'do_suspend':
> linux-next-20080528/drivers/xen/manage.c:114: error: implicit declaration of function 'device_resume'
> make[3]: *** [drivers/xen/manage.o] Error 1
>   

Thanks for the reminder.  That was on my TODO list.

    J
