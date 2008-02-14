Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYBNVM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYBNVM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763808AbYBNVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:12:13 -0500
Received: from gw.goop.org ([64.81.55.164]:57398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763046AbYBNVML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:12:11 -0500
Message-ID: <47B4AE2A.6080300@goop.org>
Date: Fri, 15 Feb 2008 08:10:02 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Mark McLoughlin <markmc@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>	<9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>	<1202988844.26435.4.camel@muff>	<1203008490.30818.69.camel@localhost.localdomain> <1203011834.30565.8.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1203011834.30565.8.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Thu, 2008-02-14 at 17:01 +0000, Ian Campbell wrote:
>   
>> I have a xen domain builder patch as well. I was waiting for the Linux
>> side to gain some traction before putting it forward (I'd attach it
>> now but it's at home on a laptop which is sleeping).
>>     
>
> Here it is:
>
> # HG changeset patch
> # User ijc@hellion.org.uk
> # Date 1203011758 0
> # Node ID 3079b4b3835e3aba52bb6548bbbced70471a9f32
> # Parent  42369d21641d6297dc369441c3bfd355880d28c0
> Support loading Linux bzImage v2.08 and up.
>   

Do you also have a patch to update the boot protocol?

    J
