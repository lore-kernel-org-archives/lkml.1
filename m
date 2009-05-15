Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZEONOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZEONOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbZEONOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:14:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762698AbZEONOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:14:40 -0400
Subject: Re: [PATCH -tip] x86: kvm/x86.c use MSR names in place of address
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1242279010.4574.6.camel@localhost.localdomain>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
	 <1242032701.3114.4.camel@localhost.localdomain>
	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
	 <1242279010.4574.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 15 May 2009 18:43:51 +0530
Message-Id: <1242393231.3082.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 11:00 +0530, Jaswinder Singh Rajput wrote:

> Here is the patch:
> 
> [PATCH -tip] x86: kvm/x86.c use MSR names in place of address
> 
> Replace 0xc0010010 with MSR_K8_SYSCFG and 0xc0010015 with MSR_K7_HWCR.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---

This patch can also apply to kvm tree without any changes.

Thanks,

--
JSR

