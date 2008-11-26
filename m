Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYKZE4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYKZE4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYKZE4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:56:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54010 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYKZE4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:56:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       fweisbec@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, srostedt@redhat.com,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20081125223421.795046329@goodmis.org>
	<20081125223456.976670734@goodmis.org>
	<20081125144221.66eb99ad.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
	<20081125153104.ecdceed4.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251909320.26424@gandalf.stny.rr.com>
	<1227660839.12109.52.camel@nimitz>
	<alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com>
Date: Tue, 25 Nov 2008 20:50:05 -0800
In-Reply-To: <alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 25 Nov 2008 20:01:34 -0500 (EST)")
Message-ID: <m1zljndrb6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=0 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0031]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=0]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 TM2_M_BODY_EMPTY Body is empty
	*  3.5 XMEmptyBody_01 Nothing in the message body
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

