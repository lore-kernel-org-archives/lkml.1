Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXJXRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXJXRR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXJXRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:17:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXJXRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:17:48 -0400
Message-ID: <471F7E2D.3010705@zytor.com>
Date: Wed, 24 Oct 2007 10:17:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>
Subject: Re: test_and_set_bit and friends ?
References: <471DC9E8.7040104@cfl.rr.com> <471F2636.20408@cfl.rr.com>
In-Reply-To: <471F2636.20408@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Mark Hounschell wrote:
>> These calls apparently are gone. Can someone tell me why and what are
>> the replacements.
>>
>> Thanks in advance
>> Mark
> 
> I got no response from the glibc people on this and the kernel-newbies
> list appears dead so I thought I'd try here since these calls are/were
> actually kernel based to begin with. Why are they no longer available in
> user space and what is one supposed to use now?
> 

There was talk of a libarch for these sorts of things.  Don't know if 
that ever happened.

	-hpa
