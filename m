Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYG1WnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYG1WnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG1WnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:43:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37951 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYG1Wm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:42:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
References: <20080727234529.GM6175@verge.net.au>
	<20080728015117.GA12055@verge.net.au>
	<20080728024526.GB3334@verge.net.au>
	<20080728034007.GA30450@verge.net.au>
	<20080728211025.GA9985@redhat.com>
Date: Mon, 28 Jul 2008 15:37:56 -0700
In-Reply-To: <20080728211025.GA9985@redhat.com> (Vivek Goyal's message of
	"Mon, 28 Jul 2008 17:10:25 -0400")
Message-ID: <m1od4hhby3.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=0 
X-Spam-Combo: ******;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0182]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=0]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 TM2_M_BODY_EMPTY Body is empty
	*  9.0 XMEmptyBody_01 Nothing in the message body
Subject: Re: [PATCH 1/5] Move elfcorehdr_addr out of vmcore.c (Was: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr')
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

