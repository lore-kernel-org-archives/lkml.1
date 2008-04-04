Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbYDDJl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbYDDJl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYDDJls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:41:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYDDJlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:41:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: kernel panic ip_route_input
Date: Fri, 4 Apr 2008 11:41:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, nuclearcat@nuclearcat.com
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.Fm.gEW9HB@albercik> <20080403.180601.59158429.davem@davemloft.net>
In-Reply-To: <20080403.180601.59158429.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041141.59396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of April 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
> 
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10324
> > Subject		: kernel panic ip_route_input
> > Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> > Date		: 2008-03-25 12:48 (10 days old)
> 
> This has been confirmed by the reporter to be fixed in the current
> tree.

I've closed the bug.

Thanks,
Rafael
