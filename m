Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYFQUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYFQUtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYFQUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:49:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbYFQUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:49:08 -0400
Message-ID: <4858227D.4090708@kernel.org>
Date: Tue, 17 Jun 2008 13:45:49 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make asm/asm.h work for asm code.
References: <4856E3D3.2010207@goop.org> <4856EDD3.4080808@kernel.org> <4856F261.9040504@goop.org> <4856F37F.9070609@kernel.org>
In-Reply-To: <4856F37F.9070609@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> I'll pull this into -tip once I figure out which topic it should go under.
> 

I applied this to x86/cleanups last night.

	-hpa
