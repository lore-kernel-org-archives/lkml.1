Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbZHEIL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbZHEIL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933743AbZHEIL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:11:26 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37539 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741AbZHEILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WLoHigDuuSQ5Pm+6LRdQlo1SHxAVanHBCAkqfMi5JPGZCjaLf6T52DHeSXpPvf0npI
         4x99efzEE6f8BiyGJJnkEvhLXca+sCH/5BXFdWWALgJEsopqtk36tMaiLRABPPr+TWb6
         A1Q6qiHqnJCF2MndiIL/TZHZlcCioAXS5x/EM=
Message-ID: <4A793EA8.50306@panasas.com>
Date: Wed, 05 Aug 2009 11:11:20 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 5
References: <20090805172337.b0688db1.sfr@canb.auug.org.au>
In-Reply-To: <20090805172337.b0688db1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 10:23 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090804:
> 
> This tree fails to build for powerpc allyesconfig (final link problem).
> 

Above is reported for a long time. Is it related to this:
http://www.spinics.net/lists/kernel/msg921978.html

> The mfd tree gained a conflict against the input tree.
> 
> The drm tree gained a conflict against Linus' tree.
> 
> The edac-amd tree gained a conflict against Linus' tree.
> 
> ----------------------------------------------------------------------------
> 
<snip>
