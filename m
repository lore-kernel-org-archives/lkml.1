Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZHYNxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZHYNxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZHYNxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:53:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49463 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZHYNxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:53:31 -0400
Message-Id: <4A9408FC02000078000119B1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 25 Aug 2009 14:53:31 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>, <mingo@redhat.com>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils and
	 consolidate linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
 <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
 <20090825075029.GA857@elte.hu>
In-Reply-To: <20090825075029.GA857@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 25.08.09 09:50 >>>
>
>* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:
>
>> Commit-ID:  ddc98b38b6320d5de2e3167673a06ec1a48e9d0e
>> Gitweb:     http://git.kernel.org/tip/ddc98b38b6320d5de2e3167673a06ec1a48e9d0e 
>> Author:     Jan Beulich <JBeulich@novell.com>
>> AuthorDate: Tue, 18 Aug 2009 16:51:27 +0100
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Mon, 24 Aug 2009 15:51:35 -0700
>> 
>> x86: Fix build with older binutils and consolidate linker script
>
>this breaks the build with newer binutils:

With the updated patch just submitted I made sure UP and SMP builds
work as well as building with old and current binutils. Sorry for having
forgotten to do so before submitting the first time (I know I had
intended to).

Jan

