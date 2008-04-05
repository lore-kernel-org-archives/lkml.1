Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYDETqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYDETqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 15:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYDETqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 15:46:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:59734 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYDETqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:46:14 -0400
Message-ID: <47F7D7AE.6090702@tmr.com>
Date: Sat, 05 Apr 2008 15:49:02 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andre Tomt <andre@tomt.net>,
       Matthew Ranostay <mranostay@embeddedalley.com>
Subject: Re: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no
 analog sound
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.Cu.0EW9HB@albercik>
In-Reply-To: <pdYe6zNQVl.A.Cu.0EW9HB@albercik>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
> Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
> Submitter	: Andre Tomt <andre@tomt.net>
> Date		: 2008-03-21 20:03 (14 days old)
> References	: http://lkml.org/lkml/2008/3/21/295
> Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>
> 
> 
Is this by any chance related to the RTC old/new vs. sound problem noted 
in another thread?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
