Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYDNKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYDNKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYDNKR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:17:59 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:56149 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbYDNKR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:58 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Mon, 14 Apr 2008 20:17:47 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080414101747.GI29599@tull.net>
References: <20080411154053.GD18242@tull.net> <20080413084536.GB24429@elte.hu> <20080413112522.GD29599@tull.net> <20080414094603.GB3761@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414094603.GB3761@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:46:03AM +0200, Ingo Molnar wrote:
> * Nick Andrew <nick@nick-andrew.net> wrote:
> > I wouldn't know that, but I still have to use 'noapic' to get my AMD 
> > box to boot :-(
> 
> oh. If "noapic" is still necessary with x86/latest:
> 
>   http://people.redhat.com/mingo/x86.git/README

Thanks; I'll retest on latest then. I didn't realise the problem was
fixed.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
