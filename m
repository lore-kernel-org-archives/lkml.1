Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYGTUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYGTUha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGTUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 16:37:22 -0400
Received: from mx0.towertech.it ([213.215.222.73]:46274 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752022AbYGTUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 16:37:21 -0400
Date: Sun, 20 Jul 2008 22:37:17 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] [patch 2.6.26] rtc-cmos: improve HPET IRQ glue
Message-ID: <20080720223717.0a5427f1@i1501.lan.towertech.it>
In-Reply-To: <200807171043.24586.david-b@pacbell.net>
References: <200807171043.24586.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 10:43:24 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Resolve bugzilla #11051 and other bugs related to the way the
> HPET glue code in rtc-cmos was incomplete and inconsistent:

 [..]
>    
> This still leaves various holes in the HPET glue, like the emulated
> update IRQs being out of sync with the RTC, alarms never using day
> or month matches, and many extra IRQs (at 64 Hz).
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

