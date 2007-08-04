Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbXHDAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbXHDAvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbXHDAvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 20:51:46 -0400
Received: from jan-robben.demon.nl ([83.160.142.71]:43419 "EHLO mail.robben.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbXHDAvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 20:51:45 -0400
Message-ID: <46B3CDA0.90804@gert.robben.nu>
Date: Sat, 04 Aug 2007 02:51:44 +0200
From: Gert Robben <lkml@gert.robben.nu>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: mjander@embedded.cl, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: snd-au8830: dead after software suspend
References: <46B3A4F5.2000708@gert.robben.nu> <46B3C44D.7020801@gert.robben.nu>
In-Reply-To: <46B3C44D.7020801@gert.robben.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Have you reported this to the ALSA people?
>> No, I thought this might as well be something for PCI or PM people, and 
>> I expected some ALSA people are also reading this list.
>> If not, where else should I report this exactly?
> alsa-devel [...] the author of the driver
Done (original message below). Thanks again :)

Gert Robben wrote:
> After a suspend-resume cycle (using Suspend2), my sound card doesn't 
> work anymore. It works again after reloading the module.
> 
> dmesg, initial boot:
>> Linux version 2.6.22-ck1
> ----8<----
>> PCI driver au8830 lacks driver specific resume support.
> 
> dmesg, after resume, trying to use the card:
>> vortex: ac97 codec stuck busy
> 
> Thanks for any help!
> 
> Gert Robben
