Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYKSN0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYKSN0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKSNZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:25:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54795 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYKSNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:25:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, containers@lists.osdl.org
References: <m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
	<m1iqr0urb8.fsf@frodo.ebiederm.org>
	<20081106202822.a1af8a6e.akpm@linux-foundation.org>
	<m1d4h7v8jf.fsf@frodo.ebiederm.org>
	<20081107080529.6f4de3ad.akpm@linux-foundation.org>
	<m1zlk3kxfj.fsf@frodo.ebiederm.org>
	<20081119000749.GA2912@x200.localdomain>
	<20081119023507.GA5888@x200.localdomain>
Date: Wed, 19 Nov 2008 05:20:21 -0800
In-Reply-To: <20081119023507.GA5888@x200.localdomain> (Alexey Dobriyan's
	message of "Wed, 19 Nov 2008 05:35:07 +0300")
Message-ID: <m1r657j1ii.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0027]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> OK, I fixed some small issues and pushed out to proc.git so it starts
> propagate to -next.

Thanks.

Eric

