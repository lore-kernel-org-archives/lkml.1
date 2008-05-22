Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYEVQkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYEVQkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYEVQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:40:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYEVQkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:40:25 -0400
Date: Thu, 22 May 2008 10:07:53 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
Message-ID: <20080522140753.GB20613@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com> <20080520131943.GA4843@redhat.com> <4834B6AC.9090503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834B6AC.9090503@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 04:56:28PM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > 
 > > From conversation with Centaur engineers, both the newer generations
 > > of the VIA C7, and their future CPUs support PAT, with no known errata.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > 
 > Question: are there any VIA CPUs that display the PAT CPUID flag that 
 > aren't covered by the above?

No.  They only added PAT support with the current Esther (C7) generation iirc.

	Dave

-- 
http://www.codemonkey.org.uk
