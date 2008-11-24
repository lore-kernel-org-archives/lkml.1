Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYKXWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYKXWGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYKXWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:06:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45288 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYKXWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:06:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>
	<m1y6ze87w6.fsf@frodo.ebiederm.org> <4925D762.6040406@goop.org>
	<m1prkpj3nl.fsf@frodo.ebiederm.org> <49260BE7.1080909@goop.org>
	<m1tza1hffa.fsf@frodo.ebiederm.org> <492AFDFC.1020305@goop.org>
Date: Mon, 24 Nov 2008 14:02:58 -0800
In-Reply-To: <492AFDFC.1020305@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 24 Nov 2008 11:18:20 -0800")
Message-ID: <m1bpw4g4tp.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3637]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Notwithstanding the possibility that there'll be general changes to x86
> interrupt handing in the future, do you have any objection to my patches as they
> stand?  Ingo would like to see your and/or hpa's ack before accepting them.
>
> Should I repost them?

I couldn't track down the first set.  So if you could repost them with me on
the cc I can review them, and tell you if I have specific objections.
My apologies for the trouble.

Eric
