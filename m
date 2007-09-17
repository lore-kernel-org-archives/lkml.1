Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbXIQC6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbXIQC6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 22:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXIQC6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 22:58:13 -0400
Received: from mail.pro-g.com.tr ([81.214.24.101]:61684 "EHLO
	mail.pro-g.com.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXIQC6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 22:58:12 -0400
Message-ID: <46EDEDB9.1000104@pro-g.com.tr>
Date: Sun, 16 Sep 2007 20:00:09 -0700
From: "Can E. Acar" <can.acar@pro-g.com.tr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: misc@openbsd.org, linux-kernel@vger.kernel.org,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
References: <46ED7A8F.1020304@pro-g.com.tr> <200709161632.21927.dhazelton@enter.net>
In-Reply-To: <200709161632.21927.dhazelton@enter.net>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:
> On Sunday 16 September 2007 14:48:47 Can E. Acar wrote:
[snip]
>>
>> First, these developers got questionable advice from senior Linux kernel
>> developers, and SLFC (which is closely related to FSF) in the process.
> 
> IIRC, the advice was "Yes, it is legal to choose to follow only one of 
> multiple offered licenses on a project" - nothing else. They looked at the 
> patches and said "Wait, you've changed the license on files that aren't under 
> a dual license."
> 
> Hence, no problems here - no questionable advice only.

The replies suggest that some (most?) people are not aware of the
recent developments, and that it is a dual licensing issue.

This has very little to do with dual licensing right now,
there has been other developments, more "advice" from SLFC.

The code in question is Reyk's open source HAL work.
I want to emphasize. This work was NOT ever dual licensed.

Furthermore, since it is compatible with the binary HAL from
Atheros, the interface is fixed and the same both in Linux and
*BSD.  So, even the latst code divergence arguments do not
apply here. The improvements to this piece of code improve
the Open Source Atheros support, and is important for both
Linux and BSD.

Theo summarized the latest situation here, some days ago:

  http://marc.info/?l=openbsd-misc&m=118963284332223&w=2

and here is a very brief summary:

  http://marc.info/?l=openbsd-misc&m=118965266709012&w=2

If you really want to know the latest situation, please read these
links, and think about it.

Do you believe re-arranging code, renaming functions, splitting code
to multiple files, adding some adaptation code is original enough
to be a derivative work and deserve its own copyright?


Can

-- 
In theory, there is no difference between theory and practice.
But, in practice, there is.
