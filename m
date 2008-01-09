Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYAIORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYAIORT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYAIORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:17:05 -0500
Received: from main.gmane.org ([80.91.229.2]:47383 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYAIORE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:17:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Wed, 9 Jan 2008 14:16:52 +0000 (UTC)
Message-ID: <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-09, Mathieu SEGAUD <mathieu.segaud@regala.cx> wrote:
> fix your hardware clock then

It displays just the right time. On boot anyway. (Linux has had some
serious problems keeping the time after the switch from 2.6.7 to 2.6.14,
advanding even 15 minutes a day -- that ntpd doesn't seem to be able 
to keep up with -- requiring running adjtimexconfig every now and
then for new settings. But the cmos clock displays the right time.)

-- 
Tuomo

