Return-Path: <linux-kernel-owner+w=401wt.eu-S1750778AbXAXJcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750778AbXAXJcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXAXJcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:32:11 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:41486 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXAXJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:32:09 -0500
Message-ID: <45B75FDB.1000004@joow.be>
Date: Wed, 24 Jan 2007 10:32:11 -0300
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: In-tree version of new FireWire drivers available
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
In-Reply-To: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-DCC-scarlet.be-Metrics: weequay 20001; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Changes since the merge into the linux1394 tree include:
> 
>  - gap count optimization
>  - full bus management
>  - loopback for async requests to the local node
>  - a bug fix for a problem exposed by VIA 6306 controllers
>  - a typo fix from the bitfield -> mask+shift conversion.

Kristian,

What is your ETA on a the completion of the isochronous interface?

Pieter
