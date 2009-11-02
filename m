Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZKBVqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZKBVqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZKBVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:46:07 -0500
Received: from lucidpixels.com ([75.144.35.66]:60979 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbZKBVqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:46:06 -0500
Date: Mon, 2 Nov 2009 16:46:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
 hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910281915400.29166@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster>
 <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan> <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Oct 2009, Justin Piszcz wrote:

>
>
> On Thu, 22 Oct 2009, Justin Piszcz wrote:
>
>> 
>> Any other ideas?
>> 
>> Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has no 
>> load at all either.. Has anyone else reported similar problems?
>> 
>> Justin.
>> 
>
> --
>
> Currently running 2.6.31-rc1 for 2 days now, no crashes, will go to -rc2 
> later today and wait another 48 hours.
>
> Justin.
>
>

Kernel report:

2.6.31-rc1: no crash - uptime 2+ days
2.6.31-rc2: no crash - uptime 2+ days
2.6.31-rc3: no crash - uptime 2+ days
2.6.31-rc4: no crash but network kept dropping out
2.6.31-rc5: cannot test, service owner needs host available
2.6.31-rc6: cannot test, service owner needs host available
2.6.31-rc7: cannot test, service owner needs host available
2.6.31-rc8: cannot test, service owner needs host available
2.6.31-rc9: cannot test, service owner needs host available
   2.6.31.x: locks up D-state

It would be somewhere between -rc4 and 2.6.31.x.

Justin.

