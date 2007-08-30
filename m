Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXH3NDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXH3NDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXH3NDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:03:00 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:32798 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXH3NC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:02:59 -0400
Message-ID: <46D6C000.30305@davidnewall.com>
Date: Thu, 30 Aug 2007 22:32:56 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
References: <2713029743177393055@pripojeni.net>	 <7515194658758617@pripojeni.net>	 <20070828171155.GC29343@infradead.org>	 <3208.1188408545@turing-police.cc.vt.edu>	 <9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>	 <20070829192858.75aa6542@the-village.bc.nu> <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
In-Reply-To: <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it actually necessary to change the license?  With the dual-license, 
you can keep a single code-base for both BSD and Linux platforms, which 
seems terribly important to me.  It'd be awful to lose that.  It would 
be a maintenance nightmare for BSD.  Is it even possible--in real life, 
I mean--to accept GPLed patches into a BSD project?  Nightmare, I tell you!
