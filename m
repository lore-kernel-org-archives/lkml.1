Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZEEAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZEEAac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbZEEAaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:30:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbZEEAaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:30:10 -0400
Message-ID: <49FF87F1.4090403@redhat.com>
Date: Mon, 04 May 2009 20:27:29 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>, linux@horizon.com,
       Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
References: <1241471016.7444.80.camel@localhost.localdomain>
In-Reply-To: <1241471016.7444.80.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> With the v2.6.19 Linux kenrel, Roman converted the in-kernel NTP code to
> the NTPv4 reference model. 

> I then modified the SHIFT_PLL value (which defines how stiff NTP's freq
> correction is), setting it to 2, and created the second attached image
> (2.6.30-pll2.png), comparing against the 2.6.18 numbers in the first
> chart.

> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
