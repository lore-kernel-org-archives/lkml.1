Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615Ab0ATOWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0ATOWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472Ab0ATOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:22:09 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:9625 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751997Ab0ATOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:22:08 -0500
Message-ID: <4B571122.6060407@ru.mvista.com>
Date: Wed, 20 Jan 2010 17:20:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, ok@artecdesign.ee,
       sarah.a.sharp@linux.intel.com,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] Obsolete config in kernel source (USB_HCD_DMA)
References: <20100120123540.GB3580@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100120123540.GB3580@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Egger wrote:

> From 2e5a8a322a6cd74ecb77eda8f0a09a0a01c6dbc6 Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Wed, 20 Jan 2010 13:32:36 +0100
> Subject: [PATCH] The configuration Option USB_HCD_DMA is not reachable in KConfig so
>  this piece of Code is effectively dead and useless. Remove it to avoid
>  confusion.
>   

   The patch's subject should be a terse description of change, not the 
substitute for the lengthy description as in your case.

WBR, Sergei

