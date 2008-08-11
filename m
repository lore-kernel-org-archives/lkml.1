Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYHKSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYHKSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYHKSA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:00:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYHKSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:00:57 -0400
Date: Mon, 11 Aug 2008 11:00:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chandra Seetharaman <sekharan@us.ibm.com>
cc: Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch make struct scsi_dh_devlist's static
In-Reply-To: <1218477013.16794.7.camel@chandra-ubuntu>
Message-ID: <alpine.LFD.1.10.0808111058590.3462@nehalem.linux-foundation.org>
References: <1218477013.16794.7.camel@chandra-ubuntu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, Chandra Seetharaman wrote:
>
> This patch makes several needlessly global struct scsi_dh_devlist's 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

This is not a valid sign-off chain.

Was the patch originally done by Adrian? If so, where is the

	From: Adrian Bunk <bunk@kernel.org>

at the top?

And since you're forwarding it, you should be signing off on it, not just 
acking it. Otherwise, the next person in the chain can't sign off on it 
and take it.

		Linus
