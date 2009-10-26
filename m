Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZJZTvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZJZTvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZJZTvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbZJZTvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:51:36 -0400
Subject: Re: [Bug #14058] Oops in fsnotify
From: Eric Paris <eparis@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>,
       Grant Wilson <grant.wilson@zen.co.uk>
In-Reply-To: <vX3ILojF2dJ.A.GQ.Bgf5KB@chimera>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
	 <vX3ILojF2dJ.A.GQ.Bgf5KB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 15:51:29 -0400
Message-Id: <1256586689.2775.6.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 20:31 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).

Should have been fixed by:
9f0d793b52eb2266359661369ef6303838904855

At least I have my fingers crossed hoping so.  I can't make it happen
with that patch.

-Eric
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
> Subject		: Oops in fsnotify
> Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
> Date		: 2009-08-20 15:48 (68 days old)
> References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4
> 
> 


