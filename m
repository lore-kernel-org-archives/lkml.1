Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbYGQSwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbYGQSwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbYGQSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:52:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57335 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbYGQSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:52:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Daniel Hokka Zakrisson" <daniel@hozac.com>
Cc: "Pavel Emelyanov" <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, oleg@tv-sign.ru,
       akpm@linux-foundation.org
References: <487F5D6B.1090007@hozac.com> <487F5EDB.1000008@openvz.org>
	<43011.192.168.102.6.1216308280.squirrel@intranet>
	<m13am8wgk6.fsf@frodo.ebiederm.org>
	<33935.192.168.102.6.1216319954.squirrel@intranet>
Date: Thu, 17 Jul 2008 11:45:28 -0700
In-Reply-To: <33935.192.168.102.6.1216319954.squirrel@intranet> (Daniel Hokka
	Zakrisson's message of "Thu, 17 Jul 2008 20:39:14 +0200 (CEST)")
Message-ID: <m1r69stkmv.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Daniel Hokka Zakrisson" <daniel@hozac.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4779]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in   the same namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Hokka Zakrisson" <daniel@hozac.com> writes:

> Looks like you've already done that. :-) (Referring to Sukadev's email.)
> Is there any reason we don't just merge that patch?

I knew I had done something like that.  Sure let's revive the patch and send
it.   I don't know why it got lost the first time.

Eric
