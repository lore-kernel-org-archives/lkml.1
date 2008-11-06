Return-Path: <linux-kernel-owner+w=401wt.eu-S1751619AbYKFOrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbYKFOrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYKFOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:47:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40352 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752174AbYKFOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:47:13 -0500
Date: Thu, 6 Nov 2008 09:47:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       <linux-pm@lists.osdl.org>, <Matt@smtp1.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <Dave@smtp1.linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       <Andy@smtp1.linux-foundation.org>, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
In-Reply-To: <20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.44L0.0811060943480.2456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, KAMEZAWA Hiroyuki wrote:

> Hmm, people tend to make crazy hardware, oh yes. the pc may fly in
> the sky with rocket engine.

This isn't crazy at all.  I am currently working on an experiment 
called RAISE (Rapid Acquisition Imaging Spectrograph Experiment) that 
involves flying a rocket above the Earth's atmosphere to make 
measurements of the Sun.  The experiments in this rocket will be 
controlled by a computer running Linux.  See

	http://www.swri.org/3pubs/ttoday/Spring06/Solar.htm

for a slightly out-of-date description.

Alan Stern

