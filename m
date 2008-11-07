Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbYKGCP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbYKGCP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYKGCPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:15:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39120 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYKGCPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:15:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<20081106172221.dbeb5b12.akpm@linux-foundation.org>
Date: Thu, 06 Nov 2008 18:06:46 -0800
In-Reply-To: <20081106172221.dbeb5b12.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 6 Nov 2008 17:22:21 -0800")
Message-ID: <m14p2kxpah.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/7] vfs: Fix shrink_submounts
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> OK, so that's a for-2.6.28 bugfix, yes?
>
> The other six patches will fall under Alexey's procfs tree.

Fundamentally they are all bug fixes, but whatever works.

Eric

