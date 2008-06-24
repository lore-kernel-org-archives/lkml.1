Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbYFXQqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbYFXQqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYFXQqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:46:03 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:59855 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYFXQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1Rt5RChP2DCBLpDAmxZnzKYCkKF2JUoD3Qkv6aLaLdn5erEYcXbm1hg1Z1okzfyo3
         Td3iaR+g38mQhBq+c0x6llHKcjW4zRsrVYdR5mqOTmVdY+NySadRsceI57t0QlVxZ6xV
         TpDQKWH6B9bCkD5fEumtn0MXuwCppgBcNHTUU=
Date: Tue, 24 Jun 2008 20:45:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] x86: perfctr-watchdog.c - coding style cleanup
Message-ID: <20080624164533.GA19623@cvg>
References: <20080624161624.124913675@gmail.com>> <48611ec1.2234440a.679b.1a7d@mx.google.com> <20080624163622.GA8219@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624163622.GA8219@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Jun 24, 2008 at 06:36:22PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Just some code beautification. Nothing else.
| 
| applied, thanks Cyrill.
| 
| note, your mailer sets the wrong timestamps:
| 
| | Date: Thu, 01 Jan 1970 03:00:01 +0300
| | From: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| i'll edit them out of your patches so that Git doesnt get bogus dates.
| 
| 	Ingo
| 

Thanks Ingo, I've mentoined in 'reply' mail for first message
in series that somehow happened that date was screwed up.
I can resent the series if needed.

		- Cyrill -
