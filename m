Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYKCPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYKCPf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbYKCPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:35:08 -0500
Received: from main.gmane.org ([80.91.229.2]:53988 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYKCPfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:35:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: System hang from holding left shift key
Date: 03 Nov 2008 16:30:21 +0100
Message-ID: <m0d4hczv1u.fsf@localhost.localdomain>
References: <490EAB65.1000908@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: one.firstfloor.org
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> While absentmindedly holding down the left shift key as I was thinking about my
> next input, I froze the keyboard. After 3 seconds, the system sounded a high
> beep, and then a low beep after another 3 seconds. At that point, no key entry
> had any effect. From the beeps, one might conclude that the input buffer is
> full, but a CTRL/U did not clear it. Fortunately, a short press on the power
> button shut down the machine cleanly.
> 
> I don't know if this is a regression. I found it in v2.6.28-rc2, but the oldest
> kernel that I could test (v2.6.24) already has the problem.

I vaguely remember hitting something like that long ago (much earlier
2.6). But i wasn't able to stabilize it so I never reported it or
tried to track it down. But it's probably not a new problem.

-Andi


-- 
ak@linux.intel.com

