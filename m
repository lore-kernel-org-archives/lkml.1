Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYISWv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYISWv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYISWvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:51:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40056 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYISWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:51:49 -0400
Date: Fri, 19 Sep 2008 23:51:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 5/5] watchdog: introduce platform_data and remove cpu conditional code
Message-ID: <20080919225129.GD9675@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-6-git-send-email-felipe.balbi@nokia.com> <20080919190431.GA9675@flint.arm.linux.org.uk> <20080919213331.GA10156@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919213331.GA10156@frodo>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 12:33:34AM +0300, Felipe Balbi wrote:
> Well, patches 4 and 5 should be ignored. Should I resend or could I rely
> on the fact that people won't pick them up ?

Given my comments on patch 1, it's probably a good idea to resend
just 1 to 3.  We can then talk about 4 and 5 some more.

Wim - can you let me know when you merge the followup patches into your
tree please?
