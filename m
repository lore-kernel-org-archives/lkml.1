Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYGGVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYGGVh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYGGVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:37:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYGGVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:37:18 -0400
Message-ID: <48728C81.7080708@kernel.org>
Date: Mon, 07 Jul 2008 14:37:05 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
References: <200807041120.678642023@firstfloor.org> <48728A0E.7010802@kernel.org>
In-Reply-To: <48728A0E.7010802@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> This patchkit uses the 64bit machine check code which is better in many
>> ways on 32bit x86 too. This is also the basis for some future machine
>> check work.
> 
> Hi Andi,
> 
> I tried applying your patch kit to -tip, but I'm getting build failures 
> on i386; gcc-4.1.1-51.fc5.x86_64 with attached configuration.
> 

FWIW, this is rooting the branch on top of current linus.  Applied on 
top of tip/auto-x86-next or tip/master, the patch does not apply.

	-hpa
