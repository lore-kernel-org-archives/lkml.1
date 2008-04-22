Return-Path: <linux-kernel-owner+w=401wt.eu-S1765525AbYDVS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765525AbYDVS45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764884AbYDVSxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:53:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49345 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762955AbYDVSxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:53:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Containers <containers@lists.osdl.org>,
       clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com>
	<1207779313.16926.12.camel@x61.ebiederm.org>
	<20080410015955.GA18227@sergelap.austin.rr.com>
	<1207812980.7509.25.camel@x61.ebiederm.org>
	<20080422142539.GA12623@sergelap.austin.ibm.com>
Date: Tue, 22 Apr 2008 11:53:07 -0700
In-Reply-To: <20080422142539.GA12623@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 22 Apr 2008 09:25:39 -0500")
Message-ID: <m1hcdtsovg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:
>> 
>> I'm hoping to be able to get back at this in the week or so as things
>> settle down from my move.  My last patches should be in my proof of
>> concept network namespace tree, if they don't show up elsewhere.
>
> Is that the tree I'd get from
>
> git-fetch
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-netns.git
> master:ebieder.master

Yes.

> ?  So I'd add a user_ns to the struct sysfs_tag_info?
>
> If so I'll give it a whirl.

Sounds good.  My apologies I keep being almost on the verge
of getting someplace.

Eric
