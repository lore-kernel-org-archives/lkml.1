Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZJZLYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZJZLYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZJZLYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:24:38 -0400
Received: from lucidpixels.com ([75.144.35.66]:39255 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbZJZLYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:24:38 -0400
Date: Mon, 26 Oct 2009 07:24:39 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
 hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster>
 <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Oct 2009, Justin Piszcz wrote:

>
> Any other ideas?
>
> Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has no 
> load at all either.. Has anyone else reported similar problems?
>
> Justin.
>

--

Currently running 2.6.31-rc1 for 2 days now, no crashes, will go to -rc2 
later today and wait another 48 hours.

Justin.

