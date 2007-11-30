Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbXK3Sk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbXK3Sk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXK3SkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:40:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbXK3SkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:40:17 -0500
Message-ID: <47505907.5030409@zytor.com>
Date: Fri, 30 Nov 2007 10:40:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
In-Reply-To: <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> With that said, there is a significant performance penalty as all 
> Objective-C method calls are looked up symbolically at runtime for every 
> single call.

GACK!

At least C++ has vtables.

	-hpa

