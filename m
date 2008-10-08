Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYJHBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYJHBgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 21:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYJHBgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 21:36:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52197 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYJHBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:36:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<20081007222726.GA9465@kroah.com>
Date: Tue, 07 Oct 2008 18:29:57 -0700
In-Reply-To: <20081007222726.GA9465@kroah.com> (Greg KH's message of "Tue, 7
	Oct 2008 15:27:26 -0700")
Message-ID: <m1vdw3g9gq.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4978]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> bah,

Greg I want to thank you for working with me and making time to do
this even though you are not a fan of what I am doing and generally
keeping this on a technical basis.  I do appreciate it, even if I
am frustrated right now, and feeling like the bar has been set
impossibly hight.

Eric
