Return-Path: <linux-kernel-owner+w=401wt.eu-S1765502AbXEVQe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765502AbXEVQe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXEVQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:34:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52973 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbXEVQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:34:19 -0400
Message-ID: <46531B86.7030607@garzik.org>
Date: Tue, 22 May 2007 12:34:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Dave Airlie <airlied@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>	 <200705210914.22663.jbarnes@virtuousgeek.org>	 <200705210934.58559.jbarnes@virtuousgeek.org>	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>	 <4652295E.7060305@garzik.org>	 <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>	 <4652A6F9.1040502@garzik.org> <9e4733910705220906l323f3b9dw5204e7db700b30a6@mail.gmail.com>
In-Reply-To: <9e4733910705220906l323f3b9dw5204e7db700b30a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> Someone just pinged me privately asking about virtualization support
> for the console and graphics hardware. What's the plan for handling
> virtualization?

Step one:  avoid VBIOS, and drive the hardware with open source software 
we have written :)

	Jeff



