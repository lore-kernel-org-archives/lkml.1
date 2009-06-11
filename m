Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZFKSw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZFKSw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZFKSwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:52:19 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:40418 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbZFKSwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:52:19 -0400
Message-id: <4A314526.5030704@acm.org>
Date: Thu, 11 Jun 2009 12:55:50 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Chaitanya Lala <clala@riverbed.com>
Cc: martin.wilck@ts.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: Regarding patchwork patch #28003
References: <20090611173312.GA7450@clala-laptop>
In-reply-to: <20090611173312.GA7450@clala-laptop>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chaitanya Lala wrote:
> Hi,
> I have been facing the issue of the kipmid's CPU usage spiking since a long time.
> I have tested the patch sent by Martin (limit CPU time spent in kipmid (version 4)) and it solves the issue for me.
> I do not see any activity/feedback on the patch.
> Can I help in some-way to ensure that this patch is merged ?
>   
I will add this to the patchset I put out for 2.6.30, and if that goes 
well it will go into the mainstream kernel.

-corey
