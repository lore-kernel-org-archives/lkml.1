Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbZAULUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbZAULUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZAULUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:20:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbZAULUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:20:31 -0500
Message-ID: <497704E3.1040001@kernel.org>
Date: Wed, 21 Jan 2009 20:20:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, brgerst@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and	unify
 x86_32/64 code paths
References: <1232527578-1960-1-git-send-email-tj@kernel.org> <20090121092633.GA22506@elte.hu> <20090121093509.GA31613@elte.hu> <20090121104311.GA15947@elte.hu> <20090121110248.GA21659@elte.hu>
In-Reply-To: <20090121110248.GA21659@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 11:20:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i went for this solution instead - it covers more .c files and is the 
> right thing to do as well.

Heh... Looks like I'm the one who should be doing much more build
testing.  Sorry about the mess.

Thanks.

-- 
tejun
