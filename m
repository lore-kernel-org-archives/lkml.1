Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465Ab0A1SIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0A1SIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068Ab0A1SIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:08:40 -0500
Received: from lo.gmane.org ([80.91.229.12]:35263 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab0A1SIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:08:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
Date: Thu, 28 Jan 2010 16:39:29 +0000
Message-ID: <17r837-m29.ln1@chipmunk.wormnet.eu>
References: <1264597747.3607.29.camel@wall-e> <87hbq6dy2k.fsf@basil.nowhere.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> 
>> The time of 80 characters punch card and terminals are over, so i would
>> be a good thing to set the line length limit to 120. Every display today
>> should be able handle this. 
>>   
>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> Full Ack!
> 
NACK Attack!

There is a reason Knuth only put so many words on a line with TeX.

Eugh.

Cheers

-- 
Alexander Clouter
.sigmonster says: Keep out of reach of children.

