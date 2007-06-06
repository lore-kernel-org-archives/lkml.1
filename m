Return-Path: <linux-kernel-owner+w=401wt.eu-S965300AbXFFW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbXFFW6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965286AbXFFW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:57:58 -0400
Received: from lucidpixels.com ([75.144.35.66]:56380 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205AbXFFW55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:57:57 -0400
Date: Wed, 6 Jun 2007 18:57:56 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061528.44070.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061857420.2716@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>> Nope, I booted with only netconsole= options.  I have a lot of HW in
>> the box and I guess the buffer is too small.  Not sure where to
>> change it in the kernel.  Looking..
>
> It's called "kernel log buffer size" and it's in "General setup".
>
> Jesse
>

Did the dmesg output get you what you needed?  Why the few KB difference? 
:)

Justin.
