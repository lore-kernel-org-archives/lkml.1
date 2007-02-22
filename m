Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXBVViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXBVViK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXBVViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:38:10 -0500
Received: from mx0.towertech.it ([213.215.222.73]:54463 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751931AbXBVViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:38:09 -0500
Date: Thu, 22 Feb 2007 22:37:58 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch/rfc 0/6] rtc framework: remove class_device, use class
 suspend()/resume()
Message-ID: <20070222223758.55fce4b3@inspiron>
In-Reply-To: <200702221244.32442.david-b@pacbell.net>
References: <200702211945.15003.david-b@pacbell.net>
	<20070222180941.GA15289@kroah.com>
	<200702221244.32442.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 12:44:31 -0800
David Brownell <david-b@pacbell.net> wrote:

> > All of these looks good to me, feel free to add an:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > to them if you want.
> 
> Thanks ...
> 
>  
> > thanks for doing the class_device removal work, I appreciate it.
> 
> Actually the class_device removal work was because that was the
> only way to clean the RTC suspend()/remove() patch out of my
> queue, where it's been sitting since not log after those class
> suspend/resume methods started to circulate, early last summer.
> 
> It'll be good to have that finally gone!


 Hi David,

  thanks for your work. The interface system was originally
 in place because it seemed the right-thing-to-do. if it isn't,
 better to remove it ;)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

