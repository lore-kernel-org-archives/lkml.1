Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXA2Abe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXA2Abe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbXA2Abe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:31:34 -0500
Received: from main.gmane.org ([80.91.229.2]:45134 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021AbXA2Abd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:31:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [SCRIPT] Remove "space damage" from patches
Date: Mon, 29 Jan 2007 00:31:13 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerqgj0.f71.olecom@flower.upol.cz>
References: <45BD177D.6060907@student.ltu.se> <slrnerqapg.f71.olecom@flower.upol.cz> <45BD3AF7.4070902@student.ltu.se>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: Richard Knutsson <ricknu-0@student.ltu.se>, LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

29-01-2007, Richard Knutsson:
> Oleg Verych wrote:
>> Nack, big and fat. It's userspace problem.
>>
>> If our "developers" can't use or update their every-day-tools, it's a
>> shame. And this is not trolling: i'm using Jed and GNU Emacs, both are
>> ok with whitespace "production".
> Oh, I hope I didn't give the impression I wanted it in the kernel (that 
> is why i labeled it as SCRIPT and not PATCH), as you said it is a 
> userspace problem. I just thought a simple script to remove those 
> whitespace could help in an imperfect world. I prefer kate since then 
> you can see where the tabs begins (and other features).

Just to give you idea, how imperfect it is:
<http://marc.theaimsgroup.com/?l=linux-mm-commits&m=116198944205036&w=2>

Anyway, i still think programmers *must* take care of it, if they think
they _are_ Programmers. IMHO LKML already gives obligation to be one.

> Richard Knutsson
>
____

