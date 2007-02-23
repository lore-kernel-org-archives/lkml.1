Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXBWMJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXBWMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276AbXBWMJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:09:27 -0500
Received: from mx0.towertech.it ([213.215.222.73]:57163 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932274AbXBWMJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:09:26 -0500
Date: Fri, 23 Feb 2007 13:09:16 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Greg KH <greg@kroah.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [rtc-linux] Re: [patch/rfc 0/6] rtc framework: remove
 class_device, use class suspend()/resume()
Message-ID: <20070223130916.21f27e14@inspiron>
In-Reply-To: <200702221421.37768.david-b@pacbell.net>
References: <200702211945.15003.david-b@pacbell.net>
	<200702221244.32442.david-b@pacbell.net>
	<20070222223758.55fce4b3@inspiron>
	<200702221421.37768.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 14:21:36 -0800
David Brownell <david-b@pacbell.net> wrote:

> > 
> >   thanks for your work. The interface system was originally
> >  in place because it seemed the right-thing-to-do. if it isn't,
> >  better to remove it ;)
> 
> The Right Thing may also have changed a bit over time!

 eheh :)

 given that Greg also agreed, you have my
 Acked-By: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

