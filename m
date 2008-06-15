Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYFOIyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYFOIyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 04:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYFOIyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 04:54:44 -0400
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51596 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYFOIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 04:54:43 -0400
X-Authuid: nmarci
Message-ID: <4854D8C8.8080006@freemail.hu>
Date: Sun, 15 Jun 2008 10:54:32 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10864] [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.UoD.BJDVIB@albercik> <4854B71D.9080801@freemail.hu> <20080615075008.GD29552@elte.hu>
In-Reply-To: <20080615075008.GD29552@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: mail01a.mail.t-online.hu 0; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Németh Márton <nm127@freemail.hu> wrote:
> 
>> Hi,
>>
>> I already mentioned at the bug report that 2.6.26-rc6 this is fixed.
>>
>> Maybe tell your robot to first check the latest activities in the bug 
>> report since the last -rc release. What I want also to tell your robot 
>> that it should mention what actions should be taken in case the bug 
>> should be still listed or when the bug can be closed.
> 
> i think the current regression tracking methods that Rafael uses work 
> very well and i'd like to thank Rafael for those efforts - to me as a 
> subsystem maintainer it is a _very_ useful thing.
> 
> In this case there was no real harm from the "this bug is already fixed" 
> condition - just an extra email. Real harm would only come from missed 
> regressions or from incorrectly closed regressions - but those are not 
> happening.
> 
> note that there is no "robot" involved in changing the state of bugs - 
> the real important work here is done by Rafael and checking whether a 
> bug is still relevant is an inevitably manual work. The mails and 
> reports are auto-generated but crawling discussions and determining the 
> status of a regression is very hard to automate.

Sorry, I thought a robot missed my comments in the bug tracking system for
the second time:

1.
Comment was on 2008-06-06 13:27:16 ( http://bugzilla.kernel.org/show_bug.cgi?id=10864#c3 )
The mail was coming: 7 Jun 2008 22:42:57 +0200 (CEST) ( http://lkml.org/lkml/2008/6/7/193 )

2.
Comment was on 2008-06-13 23:19:53 ( http://bugzilla.kernel.org/show_bug.cgi?id=10864#c4 )
The mail was coming: 14 Jun 2008 22:12:04 +0200 (CEST) ( http://lkml.org/lkml/2008/6/14/160 )

Nevertheless the bug #10864 can be closed I think.

Regards,

	Márton Németh
