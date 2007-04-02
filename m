Return-Path: <linux-kernel-owner+w=401wt.eu-S965824AbXDBUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965824AbXDBUdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965829AbXDBUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:33:41 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965824AbXDBUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:33:40 -0400
Message-ID: <46116898.5050701@zytor.com>
Date: Mon, 02 Apr 2007 13:33:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <adaslbiecxg.fsf@cisco.com>
In-Reply-To: <adaslbiecxg.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
>  > Obviously, anyone who adheres to the published interface can use one
>  > of these VID:DIDs -- as far as I'm concerned, even hardware vendors;
>  > we'll use the SID to distinguish between implementations.
> 
> I think for this to work, some attempt at a conformance testing
> program is required...
> 

How would you propose one goes about that?  It seems to me the only 
plausible thing is "does it work with the unmodified driver included in 
the Linux kernel?"  What else can one realistically do?

	-hpa
