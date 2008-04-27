Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYD0TOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYD0TOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763534AbYD0TO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:14:26 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:42852 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763488AbYD0TOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:14:21 -0400
Message-ID: <4814D083.4070307@mandic.com.br>
Date: Sun, 27 Apr 2008 16:14:11 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, jengelh@computergmbh.de, lkml@rtr.ca,
       tvrtko@ursulin.net
Subject: Re: Western Digital GreenPower drives and Linux
References: <256077993@web.de>
In-Reply-To: <256077993@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de escreveu:
>   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       853
> 193 Load_Cycle_Count        0x0032   170   170   000    Old_age   Always       -       90960
> 
> absolutely scary.....
> 
> meanwhile, i got wdidle3 from WD support and set it to 25secs (factory support seems to be at 8 secs) - but still waiting for an answer if this is a bug or not. 
> 
> i`m really wondering why support is so quiet here....
> anybody got a response from support about this? 

This is mine:

Power_On_Hours   0x0032 085 085 000 Old_age Always 6261
Load_Cycle_Count 0x0032 065 065 000 Old_age Always 355089

Model Family:     Toshiba 2.5" HDD series (80 GB and above)
Device Model:     TOSHIBA MK1032GAX
Serial Number:    75QW2718S
Firmware Version: AB211A
User Capacity:    100,030,242,816 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Apr 27 15:55:19 2008 BRT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Regards,
Renato S. Yamane
