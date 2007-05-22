Return-Path: <linux-kernel-owner+w=401wt.eu-S1765867AbXEVIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765867AbXEVIRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764671AbXEVIRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:17:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49738 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbXEVIRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:17:04 -0400
Message-ID: <4652A6F9.1040502@garzik.org>
Date: Tue, 22 May 2007 04:16:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>	 <200705210914.22663.jbarnes@virtuousgeek.org>	 <200705210934.58559.jbarnes@virtuousgeek.org>	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>	 <4652295E.7060305@garzik.org> <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
In-Reply-To: <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>> It is a quite sensible idea.
>>
>> The userspace X server SHOULD be running under a non-root user, with
>> appropriate fine-grained privs granted to it.
>>
>> "I need root to do graphics" is a myopic, antiquated view of the world.
> 
> Did I say the X server? There are policy decisions that are root only
> also authorisation of processes to render etc..

Root only today, maybe, but this thread is talking about future 
directions.  Don't lock your design into a coarse-grained security model.


> I'm not sure we can punt all that in-kernel.

See my response to Alan.

	Jeff



