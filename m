Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYAURkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYAURkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYAURjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:39:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYAURjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:39:53 -0500
Message-ID: <4794D8C4.3000306@zytor.com>
Date: Mon, 21 Jan 2008 09:39:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
References: <200801192045.17291.yinghai.lu@sun.com> <200801202140.57829.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de> <200801202257.47195.yinghai.lu@sun.com> <20080121172437.GA6722@cvg>
In-Reply-To: <20080121172437.GA6722@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> is it possible to change 'l' and 'h' to 'low' and 'high'?
> 'cause 'l' does look like '1' (one) number...
> 

I think you should use a different font.  Otherwise we're soon in a 
position where we can't abbreviate anything that starts with L and keep 
using lower case throughout.  That doesn't seem like a valid tradeoff to me.

There are plenty of fonts which have good visual distinction between l 
and 1 and O and 0.

	-hpa
