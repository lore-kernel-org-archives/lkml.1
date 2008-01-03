Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYACCbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYACCbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYACCaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:30:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYACCav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:30:51 -0500
Message-ID: <477C48BD.9010508@zytor.com>
Date: Wed, 02 Jan 2008 18:30:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fault_{32|64}.c unify do_page_fault
References: <1199322063.6323.72.camel@brick>	 <20080103014550.GA7377@martell.zuzino.mipt.ru> <1199326158.6323.87.camel@brick>
In-Reply-To: <1199326158.6323.87.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>> There is no such thing as CONFIG_x86_64 .
> 
> My apologies, testing/compiling on X86_32 here.

Please also compile for x86-64, even if you can't easily test it 
(although you can always boot under qemu, even if it's slow.)

Unification patches especially.

	-hpa
