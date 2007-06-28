Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbXF1XX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbXF1XX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763473AbXF1XXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:23:19 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:15966 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763604AbXF1XXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:23:18 -0400
Date: Thu, 28 Jun 2007 17:23:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: speedstep-centrino (no such device)
In-reply-to: <fa.jQgBX5GocqZWw6ordgUe/I1tfb0@ifi.uio.no>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <468442D4.2030900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.jQgBX5GocqZWw6ordgUe/I1tfb0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renato S. Yamane wrote:
> Hi,
> 
> Is impossible use speedstep in my Laptop with Pentium M 1,86Ghz:
> 
> #modprobe speedstep-centrino
> FATAL: Error inserting speedstep_centrino 
> (/lib/modules/2.6.18-3-686/kernel/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.ko): 
> No such device
> 
> To do that (speedstep), I need install powersaved, but 
> speedstep-centrino is not used.
> 
> More information can see in:
> <https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/66812>

I believe acpi-cpufreq is preferred over speedstep-centrino in most 
cases today, does that work?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

