Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYAURu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYAURu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYAURuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:50:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:15767 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYAURuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DtUvMRLQYPLFYm33vZDMRIgYoXfQC1Kg914gvjJnmIHk2TBSvtIFPovTp6s/jUc5fw5ZsbuPgvMGF6kpX8+OlXUcTocBSr/YYFucWhfniHmd3Ale9+R1poTow8060k+rlhn/0IqDw5MeJDkeU/TPxPDO0VprsDcAM1DSCCd9eGk=
Date: Mon, 21 Jan 2008 20:49:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
Message-ID: <20080121174954.GC6722@cvg>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202140.57829.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de> <200801202257.47195.yinghai.lu@sun.com> <20080121172437.GA6722@cvg> <4794D8C4.3000306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4794D8C4.3000306@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Mon, Jan 21, 2008 at 09:39:16AM -0800]
> Cyrill Gorcunov wrote:
>> is it possible to change 'l' and 'h' to 'low' and 'high'?
>> 'cause 'l' does look like '1' (one) number...
>
> I think you should use a different font.  Otherwise we're soon in a 
> position where we can't abbreviate anything that starts with L and keep 
> using lower case throughout.  That doesn't seem like a valid tradeoff to 
> me.
>
> There are plenty of fonts which have good visual distinction between l and 
> 1 and O and 0.
>
> 	-hpa
>

Hi Peter,

of course you're right!!! but... actually the only several symbols
affected on this: 1-l, O-0 (maybe a few more, dunno) and that is the
case for one-letter-ID only and that is so easy to avoid a such situation.

Anyway - as you wish ;)

		- Cyrill -
