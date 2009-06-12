Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZFLGoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZFLGoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZFLGoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:44:30 -0400
Received: from slackware.com ([64.57.102.34]:48756 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZFLGo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:44:29 -0400
X-Greylist: delayed 3183 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 02:44:29 EDT
Date: Thu, 11 Jun 2009 22:51:24 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: ilw@linux.intel.com
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: iwlagn crash on 2.6.29.4
Message-ID: <alpine.LNX.1.10.0906112246330.23960@bob.slackware.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.29.4, I just got a crash in iwlagn under heavy network
throughput.  I was transferring a dvd iso from one box in my
lan to another, and the following occurred:

   http://slackware.com/~rworkman/OOPS

It didn't bring the entire system to a halt (thankfully);
removing and reloading the iwlagn module made everything
just fine. :-)

If any more information is needed, let me know.  I'm more than
willing to test patches and such...

-RW
