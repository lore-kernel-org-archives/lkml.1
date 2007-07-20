Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbXGTR31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbXGTR31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbXGTR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:29:17 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:37041 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758836AbXGTR3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:29:16 -0400
X-Greylist: delayed 702 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 13:29:16 EDT
Date: Fri, 20 Jul 2007 18:17:29 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-ID: <20070720171729.GA19935@deepthought>
References: <46A0210E.6010207@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <46A0210E.6010207@tmr.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 10:42:22PM -0400, Bill Davidsen wrote:
> I just found a machine which will resume after suspend to memory, using 
> the mainline kernel (no suspend2 patch).
> 
> On resume I was looking at the uptime output, and it was about six 
> minutes, FAR longer than the time since resume. So the topic for 
> discussion is, should the uptime be
> - time sine the original boot
> - total uptime since first boot, not counting the time suspended
> - time since resume
> - some other time around six minutes
> 
> Any of the first three could be useful and "right" for some casesm thus 
> discussion invited.
> 
 My ibook has always been able to suspend to RAM.  For a long while,
uptime was shown as the time since the last boot.  At some point,
maybe about a year ago, this was "corrected" to show time since boot
_less_ time suspended.

 To be clear, the ibook suspends when I close the lid and resumes
when I open it.  Uptime used to be convenient, because I could work
out when I'd last booted.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
