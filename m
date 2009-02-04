Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZBDXOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZBDXOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZBDXOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:14:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZBDXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:14:23 -0500
Message-ID: <498A2129.4030408@zytor.com>
Date: Wed, 04 Feb 2009 15:13:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
References: <20090204192551.GA19539@elte.hu> <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain> <20090204225848.GA3251@elte.hu>
In-Reply-To: <20090204225848.GA3251@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> The solution is (based on Linus's suggestion) to compare 64-bits
                                                   ^not, presumably
> (on 64-bit x86), but to do the comparison on 32-bit signed
> integers.

	-hpa
