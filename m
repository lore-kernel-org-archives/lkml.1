Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbYFIMzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbYFIMzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYFIMys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:54:48 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:3885 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbYFIMyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:54:47 -0400
Message-ID: <484D2813.3060500@netone.net.tr>
Date: Mon, 09 Jun 2008 15:54:43 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: ciaby <ciaby@autistici.org>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] 2.6.25.4-rt6: missing global_rt_runtime() in sched.c
References: <7688fdc041a8f848b0627dccccddcf12@localhost>
In-Reply-To: <7688fdc041a8f848b0627dccccddcf12@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2008 12:52:10.0693 (UTC) FILETIME=[A1CD7750:01C8CA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ciaby wrote:
> I already sent this patch, but seems that nobody cared... the last 2
> revisions of the -rt kernel don't compile properly.
> Second patch to fix this.
> Regards
>
> Giovanni "ciaby" Civardi
>   
Thanks for the patch. It worked perfectly for me.
