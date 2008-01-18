Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbYARVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbYARVyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbYARVym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:54:42 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:53950 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbYARVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:54:41 -0500
Message-ID: <47912016.9040907@freescale.com>
Date: Fri, 18 Jan 2008 15:54:30 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jochen Friedrich <jochen@scram.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
References: <478F4AE3.5090803@scram.de> <20080118183905.2d5d8474@lxorguk.ukuu.org.uk> <4790F44F.8020009@scram.de> <20080118204030.48fbb683@lxorguk.ukuu.org.uk> <EC416CBA-9200-4D71-8D95-39798937203D@kernel.crashing.org>
In-Reply-To: <EC416CBA-9200-4D71-8D95-39798937203D@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> So I'll ask, what serial input are you waiting for from the boot wrapper?

The bootwrapper has a command line editing prompt.  It's fairly 
gratuitous in the presence of semi-decent firmware, but it's there 
nonetheless.

-Scott
