Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXL0Skw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXL0Skw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXL0Skn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:40:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:39170 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752221AbXL0Skm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:40:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199ZPh+p2N9UNepoOZY+0KLPH5ewquKkf6hjDQMxG
	PvyuKRGY6AFPcE
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1198780063.4425.59.camel@homer.simson.net>
References: <fa./Gg6lFn4vN7sfhp2nE3LSMDm0q4@ifi.uio.no>
	 <4773EA58.2040605@shaw.ca>  <1198780063.4425.59.camel@homer.simson.net>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 19:40:40 +0100
Message-Id: <1198780840.4425.61.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 19:27 +0100, Mike Galbraith wrote:
> On Thu, 2007-12-27 at 12:09 -0600, Robert Hancock wrote:
> 
> > Are we missing some logic to resync the TSCs after resume, or something?
> 
> They used to be forcibly synchronized during boot, but it seems that was
> dropped in 2.6.21.

(but out of sync isn't my problem, it's TSC having been reset)

