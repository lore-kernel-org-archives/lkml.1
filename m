Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbYCEXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbYCEXIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbYCEXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:02:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbYCEXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:02:55 -0500
Message-ID: <47CF25A5.5060709@zytor.com>
Date: Wed, 05 Mar 2008 14:58:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Matz <matz@suse.de>
CC: David Miller <davem@davemloft.net>, richard.guenther@gmail.com,
       Joe.Buck@synopsys.com, hubicka@ucw.cz, aurelien@aurel32.net,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com> <20080305.141622.80343656.davem@davemloft.net> <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de>
In-Reply-To: <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Matz wrote:
> 
> Many bugs are a big issue to people who actually hit them, and we had (and 
> probably still have) far nastier corner case miscompilations here and 
> there and nevertheless released.  It never was the end of the world :)
> 

This is the sort of stuff that security holes are made from.

	-hpa
