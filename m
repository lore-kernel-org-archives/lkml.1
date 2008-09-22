Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYIVUfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYIVUfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYIVUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:35:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41836 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYIVUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:35:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
Date: Mon, 22 Sep 2008 13:24:28 -0700
In-Reply-To: <20080922153455.GA6238@kroah.com> (Greg KH's message of "Mon, 22
	Sep 2008 08:34:55 -0700")
Message-ID: <m163ooq683.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: greg@kroah.com, serue@us.ibm.com, linux-kernel@vger.kernel.org, benjamin.thery@bull.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0219]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> I only got so far through the patch set and then got interrupted (was at
> different conferences for 2 weeks), sorry.  I'll get the rest of the
> patchset added later today.

Thanks.  I was just going to ask about it.

> Note, I did talk to Al Viro about these patches last week at the kernel
> summit, and he advised holding off on sending them to mainline before he
> could review them.  So I'll keep them in my tree for now, but not push
> them to Linus until he acks them as he raised a few issues in our
> conversation.

If Al is willing to do a timely review I'm happy to see it.
That is the point of having the code in a tree after all.

Eric
