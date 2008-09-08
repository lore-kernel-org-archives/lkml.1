Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYIHSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYIHSzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYIHSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:55:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYIHSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:55:32 -0400
Message-ID: <48C57439.3040903@zytor.com>
Date: Mon, 08 Sep 2008 11:51:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>	<48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org>
In-Reply-To: <20080908114619.741b6786@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> the ideal case would be "support them all"
> 

Not really.  That would include things like the i386, which is a bunch 
of really nasty stuff.

	-hpa
