Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXITI7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXITI7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXITI7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:59:05 -0400
Received: from mx0.towertech.it ([213.215.222.73]:43581 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750952AbXITI7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:59:04 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 04:59:04 EDT
Date: Thu, 20 Sep 2007 10:51:58 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Chuck Ebbert <cebbert@redhat.com>,
       tilman@imap.cc, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070920105158.44ddaac5@i1501.lan.towertech.it>
In-Reply-To: <20070919231121.e481445c.akpm@linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070919170604.f7e82f19.akpm@linux-foundation.org>
	<200709192143.14635.david-b@pacbell.net>
	<20070919231121.e481445c.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 23:11:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> b) The kernel is trying to register two procfs files of the same name! 
>    If that's a configuration error then we have a Kconfiguration bug.

 I guess the best solution would be to have Kconfig avoid that. I'll try
 to code something as soon as I get back home.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

