Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYJaA3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYJaA3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYJaA3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:29:22 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:2606 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbYJaA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:29:21 -0400
Message-ID: <490A5165.3090705@lougher.demon.co.uk>
Date: Fri, 31 Oct 2008 00:29:25 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
References: <E1Kv0C3-0006GU-ES@dylan> <1225316373.3199.276.camel@calx>
In-Reply-To: <1225316373.3199.276.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, 2008-10-29 at 01:49 +0000, Phillip Lougher wrote:
>> Hi,
>>
>> This a respin of the Squashfs patches incorporating the review comments
>> received.  Thanks to everyone who have sent comments.
> 
> I read over the v3 source a few weeks ago and must say this looks
> greatly improved. 
> 

Yes thanks.  The v3 source was a bit of a mess, it had grown organically 
from the earliest version of Squashfs, and long needed restructuring, 
closer attention to coding standards, and commenting.  I think the v4 
source is a major improvement, it's partially thanks to CELF that I got 
the necessary time off work to knock it into shape.

Phillip

