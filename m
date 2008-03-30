Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYC3J4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYC3J4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 05:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYC3J41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 05:56:27 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:36506 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYC3J40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 05:56:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlVaAAYB70dT48OPPGdsb2JhbACBWo9eAQEBATCWMA
Message-ID: <47EF71CE.70402@coderworld.net>
Date: Sun, 30 Mar 2008 11:56:14 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net> <20080329234358.GA28667@linux.vnet.ibm.com> <47EED858.7010605@coderworld.net> <47EEE2E0.4070009@coderworld.net> <20080330093331.GE30270@linux.vnet.ibm.com>
In-Reply-To: <20080330093331.GE30270@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani skrev:
> Is it easy to reproduce? Would it be possible for you to bisect?
> 

I have a pretty good idea how to trigger it now, but it still takes some 
time of typing to actually see it. It's easy to see if it fails, but not 
the other way around.

I will give it a try to at least narrow it down, but it will take some 
time..

regards, Richard
