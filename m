Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXJMSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXJMSSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762505AbXJMSSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:18:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762247AbXJMSSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:18:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: Suspend Broken (Re: 2.6.23-mm1)
Date: Sat, 13 Oct 2007 20:33:45 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071013175845.GA14596@linux.vnet.ibm.com>
In-Reply-To: <20071013175845.GA14596@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132033.46423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 13 October 2007 19:58, Dhaval Giani wrote:
> Hi,
> 
> I just tried 2.6.23-mm1 and suspend is not working there. automount
> refuses to go in the freezer. I've attached dmesg (three attempts to
> suspend so it gets a bit big). Suspend works on 2.6.23 and sched-devel.
> 
> Another funny thing that I've noticed on -mm is that amarok refuses to
> load a playlist. It works properly on sched-devel tree. 

Could you please try to find the patch that introduces this issue (using
bisection)?

Greetings,
Rafael
