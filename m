Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbXFSNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbXFSNXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbXFSNXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:23:07 -0400
Received: from mx0.towertech.it ([213.215.222.73]:57794 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756387AbXFSNXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:23:06 -0400
Date: Tue, 19 Jun 2007 15:22:55 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: rtc-dev.c & RTC_AIE_ON
Message-ID: <20070619152255.13693b14@inspiron>
In-Reply-To: <20070619124735.GF4374@enneenne.com>
References: <20070617173326.GU18182@enneenne.com>
	<20070619142006.43f16c4d@inspiron>
	<20070619124735.GF4374@enneenne.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:47:35 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Tue, Jun 19, 2007 at 02:20:06PM +0200, Alessandro Zummo wrote:
> > 
> >  'cos they are two different things :) I don't know how
> >  the "Lightweight At Daemon" works and if it requires AIE support.
> 
> Yes, it requires such support.
> 
> >   It would be better to use system timers to do scheduled
> >  things rather than using AIE, which is usually meant
> >  to wake up the hardware.
> 
> I see. But if I wish adding such support anyway into kernel which
> could be the "best way" to do it? :)

 I'd rather fix the daemon, but if you truly want, you may write
 some code, maybe using UIE emulation as a starter, and show the community
 why it is needed and appropriate. 

 I, personally, am against such emulation but will not oppose it
 if there is general consensus from the community.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

