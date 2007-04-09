Return-Path: <linux-kernel-owner+w=401wt.eu-S966075AbXDIQEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966075AbXDIQEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966082AbXDIQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:04:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966075AbXDIQEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:04:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc6-mm1
Date: Mon, 9 Apr 2007 18:08:22 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, lenb@kernel.org,
       venkatesh.pallipadi@intel.com
References: <20070408143559.f5014629.akpm@linux-foundation.org>
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704091808.23417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/
> 
> 
> - Lots of x86 updates
> 
> - This is a 25MB diff against mainline, which is rather large.

The cpuidle thing tends to hang my x86-64 machines on boot.

Greetings,
Rafael
