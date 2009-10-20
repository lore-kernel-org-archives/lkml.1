Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZJTNpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZJTNpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZJTNpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:45:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZJTNpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:45:23 -0400
Date: Tue, 20 Oct 2009 15:45:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>, Arjan van de Ven <arjan@infradead.org>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_X86_L1_CACHE_BYTES vs. CONFIG_X86_L1_CACHE_SHIFT
Message-ID: <20091020134512.GB3930@elte.hu>
References: <4ADD9A94020000780001ADBB@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADD9A94020000780001ADBB@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> What is the reason for having these, under various conditions 
> disagreeing (see i386_defconfig), but supposedly redundant 
> auto-selected config settings?

Mostly historic crappiness. Patches that clean up the situation would be 
welcome :)

	Ingo
