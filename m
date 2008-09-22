Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYIVQKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYIVQKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIVQJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYIVQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:09:58 -0400
Message-ID: <48D7C304.4020709@zytor.com>
Date: Mon, 22 Sep 2008 09:08:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu>
In-Reply-To: <48D73858.3070900@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> What do you think about update5? Any things still to improve, or is it
> already scheduled for inclusion in one of the upcoming kernels? If so,
> which one?
> 
> Thanks for any info,

I was out of town for LKS/LPC last week, and I didn't get a chance to 
deal with it before I left.  However, it's definitely getting there.

I will add it to the -tip tree, and assuming it doesn't cause massive 
breakage it probably will be pushed into .28.

	-hpa
