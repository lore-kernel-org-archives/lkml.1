Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbXCUWO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbXCUWO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCUWO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:14:59 -0400
Received: from gw.goop.org ([64.81.55.164]:42709 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965116AbXCUWO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:14:58 -0400
Message-ID: <4601AE62.1000908@goop.org>
Date: Wed, 21 Mar 2007 15:14:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kevin Lloyd <linux@sierrawireless.com>,
       Johannes H?lzl <johannes.hoelzl@gmx.de>,
       Kevin Lloyd <klloyd@sierrawireless.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc4: NULL pointer dereference oops when unplugging sierra
 device
References: <4601A3B9.3030701@goop.org> <20070321215309.GA18940@suse.de>
In-Reply-To: <20070321215309.GA18940@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Hm, do the two patches attached below fix this problem for you?
>
> The second one might not be needed, but it is there for "correctness" :)
>   

Thanks.  I'll try it out when I next boot that kernel.

    J
