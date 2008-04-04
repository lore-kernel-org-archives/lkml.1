Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYDDBGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYDDBGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYDDBGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:06:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYDDBGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:06:02 -0400
Date: Thu, 03 Apr 2008 18:06:01 -0700 (PDT)
Message-Id: <20080403.180601.59158429.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, nuclearcat@nuclearcat.com
Subject: Re: kernel panic ip_route_input
From: David Miller <davem@davemloft.net>
In-Reply-To: <pdYe6zNQVl.A.Fm.gEW9HB@albercik>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	<pdYe6zNQVl.A.Fm.gEW9HB@albercik>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)

> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10324
> Subject		: kernel panic ip_route_input
> Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> Date		: 2008-03-25 12:48 (10 days old)

This has been confirmed by the reporter to be fixed in the current
tree.
