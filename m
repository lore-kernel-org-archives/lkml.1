Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXCMRqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXCMRqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXCMRqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:46:03 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:60737 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXCMRqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:46:01 -0400
Message-ID: <45F6E34E.9020308@nortel.com>
Date: Tue, 13 Mar 2007 11:45:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Ash Milsted <thatistosayiseenem@gawab.com>,
       Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
References: <200703121058.11966.kernel@kolivas.org> <20070313153514.428dc3e1.thatistosayiseenem@gawab.com> <75b66ecd0703130853p4c7d029en2405caee4447d29e@mail.gmail.com>
In-Reply-To: <75b66ecd0703130853p4c7d029en2405caee4447d29e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2007 17:45:54.0372 (UTC) FILETIME=[72CAF840:01C76597]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:

> Sounds like Wengophone is broken.  It should be using RT threads for
> time critical work, as JACK and Ardour2 are doing.

If the app has root privileges to set RT policy, then it could also set 
deeply negative nice values as well.

Doesn't reallly help the regular user with no privileges.

Chris
