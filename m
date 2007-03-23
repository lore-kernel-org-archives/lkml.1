Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXCWXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXCWXqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXCWXqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:46:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52087 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbXCWXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:46:51 -0400
Message-Id: <200703232346.l2NNkeSJ002093@owlet.beaverton.ibm.com>
To: linux-kernel@vger.kernel.org
cc: Prarit Bhargava <prarit@redhat.com>, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t 
In-reply-to: Your message of "Thu, 15 Mar 2007 09:22:47 EDT."
             <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> 
Date: Fri, 23 Mar 2007 16:46:39 -0700
From: Rick Lindsley <ricklind@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've seen these here and had arrived at a similar patch.  Extensive prints
on the console can take longer than the watchdog likes.

Acked-by: Rick Lindsley <ricklind@us.ibm.com>

Rick
