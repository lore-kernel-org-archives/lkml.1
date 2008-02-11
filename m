Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYBKTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYBKTP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYBKTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:15:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYBKTPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:15:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Mon, 11 Feb 2008 20:13:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Ray Lee <ray.lee@tapsys.com>,
       Pavel Machek <pavel@suse.cz>, Len Brown <len.brown@intel.com>
References: <1202664109.8394.19.camel@mtlp> <200802101954.31061.rjw@sisk.pl> <1202745386.7382.23.camel@mtlp>
In-Reply-To: <1202745386.7382.23.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112013.53850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of February 2008, Mirco Tischler wrote:
> On Sunday, 10 of February 2008, Rafaek J. Wysocki wrote:
> 
> > Can you apply the appended patch on top of the current mainline and tetest?
> > 
> > Thanks,
> > Rafael
> > 
> 
> Sorry, that doesn't fix it. 
> But I'm pretty sure it is related to that commit. Bisecting went
> straight forward to it and reverting it fixes the bug. 

Can you send me the output of acpidump from your system, please?

Rafael
