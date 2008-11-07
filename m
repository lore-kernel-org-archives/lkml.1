Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYKGBKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYKGBKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYKGBJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:09:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYKGBJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:09:54 -0500
Date: Fri, 7 Nov 2008 10:09:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       <linux-pm@lists.osdl.org>, <Matt@smtp1.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <Dave@smtp1.linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       <Andy@smtp1.linux-foundation.org>, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
 hotplug
Message-Id: <20081107100915.6c525512.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.44L0.0811060943480.2456-100000@iolanthe.rowland.org>
References: <20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.44L0.0811060943480.2456-100000@iolanthe.rowland.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 09:47:12 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 6 Nov 2008, KAMEZAWA Hiroyuki wrote:
> 
> > Hmm, people tend to make crazy hardware, oh yes. the pc may fly in
> > the sky with rocket engine.
> 
> This isn't crazy at all.  I am currently working on an experiment 
> called RAISE (Rapid Acquisition Imaging Spectrograph Experiment) that 
> involves flying a rocket above the Earth's atmosphere to make 
> measurements of the Sun.  The experiments in this rocket will be 
> controlled by a computer running Linux.  See
> 
> 	http://www.swri.org/3pubs/ttoday/Spring06/Solar.htm
> 
> for a slightly out-of-date description.
> 

interesitng :)

-Kame

> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

