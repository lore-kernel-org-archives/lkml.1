Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXLYXuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXLYXuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXLYXuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:50:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXLYXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:50:36 -0500
Message-ID: <477196DC.9000704@zytor.com>
Date: Tue, 25 Dec 2007 15:48:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86] is checkpatch.pl broken
References: <20071225170737.GA3887@cvg.org>
In-Reply-To: <20071225170737.GA3887@cvg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Hi list,
> 
> by doing cleanup of arch/x86/boot/*.[ch] i found that
> checkpatch does ignore obvious things. For example,
> run it over edd.c showed only one warning:
> 
> BTW, is there someone who is already involved in a such
> cleanup to eliminate double effort?
> 

BTW, it's more than a wee bit rude of you to Cc: a bunch of people but 
not the listed maintainer of the piece of code you're claiming to be 
cleaning up.

	-hpa
