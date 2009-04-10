Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZDJGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZDJGDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbZDJGDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:03:24 -0400
Received: from thunk.org ([69.25.196.29]:49929 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbZDJGDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:03:23 -0400
To: linux-kernel@vger.kernel.org
Subject: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
Date: Fri, 10 Apr 2009 02:03:13 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, has anyone else noticed that suspend-to-ram seems to have gotten
broken in 2.6.30-rc1, sometime during last half of the merge window?
I've been at a conference all of this past week, so I haven't had time
to bisect it yet.  I was wondering if anyone else had noticed and
figured out what was going wrong.  Symptoms are that the suspend "moon"
starts flashing and the system never manages to put itself to sleep.  

       		    	       	     	     	- Ted
