Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbYDPCMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbYDPCMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYDPCMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:12:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYDPCMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:12:43 -0400
Message-ID: <48055FC7.2020100@zytor.com>
Date: Tue, 15 Apr 2008 19:09:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Arnd Bergmann <arnd@arndb.de>, Alexia Death <alexiadeath@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com> <200804140848.39226.arnd@arndb.de> <480343F2.3040401@zytor.com> <alpine.LNX.1.00.0804151910100.19665@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0804151910100.19665@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> 
> Somewhat unsurprisingly, not all manufacturers took into account the 
> possibility that a card would use a different block size than what all of 
> the cards of the time used.
> 

What's really kind of pathetic is that designed, in 2000, a that broke 
at 1 GB...

	-hpa
