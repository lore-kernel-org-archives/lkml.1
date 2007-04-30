Return-Path: <linux-kernel-owner+w=401wt.eu-S1423288AbXD3Npb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423288AbXD3Npb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423289AbXD3Npb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:45:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:34764 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423288AbXD3Npa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:45:30 -0400
Message-ID: <4635F2F7.6010805@qumranet.com>
Date: Mon, 30 Apr 2007 16:45:27 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 13/36] Use menuconfig objects II - KVM/Virt
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301335310.29151@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704301335310.29151@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
> so that the user can disable all the options in that menu at once
> instead of having to disable each option separately.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>   

Acked-by: Avi Kivity <avi@qumranet.com>

-- 
error compiling committee.c: too many arguments to function

