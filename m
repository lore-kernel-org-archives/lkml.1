Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZIQR30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZIQR30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbZIQR3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:29:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47312 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbZIQR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:29:20 -0400
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Sep 2009 10:29:18 -0700
In-Reply-To: <20090917125759.GA4045@kroah.com> (Greg KH's message of "Thu\, 17 Sep 2009 05\:57\:59 -0700")
Message-ID: <m1ab0tcwep.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Thu, Sep 17, 2009 at 01:23:39AM -0700, Eric W. Biederman wrote:
>> 
>> devtmpfs has numerous problems.  The once I see from a quick review.
>
> <snip>
>
> I'm confused, why did you not at least cc: Kay and I on this message, if
> I was a paranoid person, I would think that you were somehow trying to
> skirt around us for some unknown reason :(

You just aren't relevant to this discussion except where you
repeatedly demonstrate you aren't willing to listen to anyone who
hasn't drunk the devtmpfs coolaid.

If you were interested in honest review and feedback you would have
copied me from the second review onward.  You didn't do that.  Why
should I extend you the courtesy.  This isn't your decision to make.

> I think Kay has raised the proper points already.

Kay blithely replied to my points but he wasn't paying attention, and
certainly did not look at how what I have said applies to the code. 

Greg this code does not live up to the standards you have repeatedly
asserted are required for accepting core kernel code.  Neither you
nor Kay show any interest in fixing even the most trivial of bugs.
Must less discuss alternate solutions to the problem.

My recommendation stands as you are unwilling to fix bugs and listen
to other peoples opinion merging the code at this time is a bad idea.

Eric
