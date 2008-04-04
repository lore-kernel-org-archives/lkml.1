Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYDDAVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYDDAVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYDDAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:20:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYDDAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:20:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Date: Fri, 4 Apr 2008 02:20:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
References: <20080403191916.GA30864@deepthought> <200804032329.22483.rjw@sisk.pl> <20080403234839.GA5181@deepthought>
In-Reply-To: <20080403234839.GA5181@deepthought>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040220.00732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of April 2008, Ken Moffat wrote:
> On Thu, Apr 03, 2008 at 11:29:21PM +0200, Rafael J. Wysocki wrote:
> > 
> > Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
> > (see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).
> > 
> > Thanks,
> > Rafael
>  Thanks for the suggestion.  Tried it on 2.6.24.4, and
> double-checked /proc/config.gz after booting -
> 
> # CONFIG_FAIR_GROUP_SCHED is not set
> 
>  Unfortunately, the first test reboot failed in the same way.

Please unset CONFIG_GROUP_SCHED too.

Thanks,
Rafael
