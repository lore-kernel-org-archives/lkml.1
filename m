Return-Path: <linux-kernel-owner+w=401wt.eu-S1031416AbXDZSOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031416AbXDZSOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031407AbXDZSOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:14:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27720 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031416AbXDZSN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=VYqBxkaFBo17mjhJOlD2BMyKht4fchaYXYRvaqfMRuInJbjDhfPcdgEInPUJhkALyUGL0aUBssD3YW5JL05SMcGatqrYy7fEHKnHKJDBFT62AG1XPV5n0aho5lsGywDrj8IQLTCa7aHLZnvH7OD+/sdj1qfoPq1avDKeskS7G4Y=
Date: Thu, 26 Apr 2007 20:13:25 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070426201325.8a1ebda3.diegocg@gmail.com>
In-Reply-To: <4630DB24.4030005@redhat.com>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 26 Apr 2007 13:02:28 -0400, Chuck Ebbert <cebbert@redhat.com> escribió:

> Problem is, not enough developers pay attention to the -stable
> series. Adrian, maybe you could shift your attention there and
> stop trying to track the bleeding edge?

>From my humble POV, it's a problem that all this discussion was generated
on what Adrian does or stop doing. Apparently, unless Adrian posts his
list of know regressions, most of the people doesn't look at the bugzilla
at all. Maybe it'd be useful to create a per-release bug tracker in the
bugzilla or collect them into one of the a kernel.org's wiki, to make easier
to follow the current state of all the "important" regressions. 
