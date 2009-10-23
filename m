Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZJWIg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZJWIg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZJWIg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:36:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:37336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZJWIgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rXtujLcRtVAFP/RHUn2pTlscZspCVgce/LQOa4dF+0TeveHi8Df2qqI4UY3eZeOuNj
         vPxCm0GX2LFXdWBDgDD1R7JLRXWdluGfQ9gX5oWOI7MjJcz0JlmZ8T28O/kl7qeuawqG
         qUZw/9dB5f/PuNm670vRU6O/bxkKmEj5DUKnk=
Message-ID: <4AE16B0A.7020400@gmail.com>
Date: Fri, 23 Oct 2009 10:36:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: writable limits to -next [was: Adding to linux-next?]
References: <4AC6339B.7000905@gmail.com> <20091006225751.7d5f3eec.sfr@canb.auug.org.au>
In-Reply-To: <20091006225751.7d5f3eec.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 01:57 PM, Stephen Rothwell wrote:
> Here is my boilerplate:
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window. 

Hi, could you please add git://decibel.fi.muni.cz/~xslaby/linux#limits
into the -next tree?

> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,

I posted the patches twice, nobody seems to want to pick them up.
The last repost is at:
http://lkml.org/lkml/2009/10/17/126

>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.

I'll try to merge it to 2.6.33.

Thanks.
