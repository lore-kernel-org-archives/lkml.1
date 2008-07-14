Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYGNWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYGNWXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYGNWWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:22:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYGNWWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:22:52 -0400
Message-ID: <487BD0E3.8020001@kernel.org>
Date: Mon, 14 Jul 2008 15:19:15 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/3] x86_64: further cleanup of 32-bit compat syscall
 mechanisms
References: <487877B8.8010505@goop.org> <487A963E.6040307@kernel.org> <487BCC25.9030204@goop.org>
In-Reply-To: <487BCC25.9030204@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> Acked-by: H. Peter Anvin <hpa@zytor.com> 
> 
> Have these been applied to anything yet?
> 

Just applied them to xen-64bit, thanks!

	-hpa
