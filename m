Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZDVHXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZDVHXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZDVHWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:22:47 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52340 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570AbZDVHWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:22:45 -0400
Message-ID: <49EEC60F.2010706@pardus.org.tr>
Date: Wed, 22 Apr 2009 10:23:59 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: cpufreq@vger.kernel.org, mingo@redhat.com
Subject: Re: [BUG 2.6.30_rc1] powernow-k8: oops during initialization
References: <49E7175D.6060808@pardus.org.tr>
In-Reply-To: <49E7175D.6060808@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan wrote On 16-04-2009 14:32:
> Hi,
>
> Just have time to try 2.6.30_rc1 and had an oops during powernow-k8
> initialization.
> I'm giving the config file and full dmesg output.
>
> The cpu is an AuthenticAMD Athlon 64 X2 Dual Core Processor 4800+,
> family 15 model 107
>
>   
I'm still having this problem with today's 2.6.30_rc3.

There's a patchset from "Rusty Russell: cpumask: avoid playing with
cpus_allowed in powernow-k8"
sent on 13/04/2009 that I suspect it may be the solution but I didn't
have time to give it a try.

Regards,
