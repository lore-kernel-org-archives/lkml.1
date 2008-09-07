Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYIGDSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYIGDSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 23:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYIGDSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 23:18:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYIGDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 23:18:45 -0400
Message-ID: <48C34803.60006@zytor.com>
Date: Sat, 06 Sep 2008 20:18:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
In-Reply-To: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> 
> This version applies to kernel 2.6.26.3
> 

Could you produce a version against the -tip tree, either the master 
branch or the x86/setup branch?

	-hpa
