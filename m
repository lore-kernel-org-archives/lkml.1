Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZBMTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZBMTAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761581AbZBMS7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:59:33 -0500
Received: from gw.goop.org ([64.81.55.164]:48715 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761576AbZBMS7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:59:32 -0500
Message-ID: <4995C312.70401@goop.org>
Date: Fri, 13 Feb 2009 10:59:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <4995C157.9020102@goop.org> <20090213185500.GA2186@elte.hu>
In-Reply-To: <20090213185500.GA2186@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> it is in tip:master, due to:
>
>  0fb807c: unconditionally include asm/types.h from linux/types.h
>  527bdfe: make linux/types.h as assembly safe
>   
OK, but that change isn't in x86/headers, so it won't compile standalone.

    J
> 	Ingo
>   

