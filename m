Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXCUXVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXCUXVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXCUXVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:21:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXCUXVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:21:51 -0400
Date: Wed, 21 Mar 2007 18:29:08 -0400
From: Dave Jones <davej@redhat.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH 2/2] Export deferrable timer through workqueue and use it in ondemand governor
Message-ID: <20070321222908.GA9092@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>,
	Andrew Morton <akpm@osdl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
References: <20070321202339.GB29367@linux-os.sc.intel.com> <20070321220456.GA3796@redhat.com> <8F4448F7-640A-4741-8121-875A104DCA7F@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8F4448F7-640A-4741-8121-875A104DCA7F@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:19:45PM -0700, Venki Pallipadi wrote:

 > init_timer_deferrable is defined in
 > [PATCH 1/2] Add support for deferrable timers
 > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/2064.html
 > 
 > Do you get this error after that patch?

Ah, looks like I had 1/2 from the previous iteration of this patch.

	Dave

-- 
http://www.codemonkey.org.uk
