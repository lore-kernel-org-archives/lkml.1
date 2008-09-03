Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYICX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYICX2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYICX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:27:56 -0400
Received: from inhex.net ([193.33.178.145]:41770 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYICX1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:27:55 -0400
Date: Thu, 4 Sep 2008 02:27:48 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [patch 0/6] final clockevents/hpet fixes
Message-ID: <20080903232748.GA2408@laptop.local>
References: <20080903212735.713411776@linutronix.de> <20080903230003.GA1958@laptop.local> <alpine.LFD.1.10.0809040102560.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809040102560.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 01:04:00AM +0200, Thomas Gleixner wrote:
> Dimitry, thanks for testing.
> 
> Are you up for another debug session in the next days to figure out
> why the x86 tree exposes this IPI warning ?
> 

Sure. I'm subscribed to LKML however don't read it often. So please CC me

-- 
WBR, Dmitry
