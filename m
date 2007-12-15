Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbXLOBqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbXLOBqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbXLOBqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:46:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXLOBqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:46:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ray Lee" <ray@madrabbit.org>
Subject: Re: Regression: Wireshark sees no packets in 2.6.24-rc3
Date: Sat, 15 Dec 2007 03:05:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <2c0942db0712131746s7da91f2bkf45b3e1ddf16d1f3@mail.gmail.com>
In-Reply-To: <2c0942db0712131746s7da91f2bkf45b3e1ddf16d1f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150305.02589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of December 2007, Ray Lee wrote:
> tshark -i eth0, eth1, lo are all empty. Works under 2.6.23.0 just
> fine. A quick scan of the log between 2.6.24-rc3 and current tip
> (-rc5) doesn't show any obvious fixes, but then again, what do I know.
> I'll check current tip on the weekend when I'll have the luxury to
> have my main system down long enough for a test. Right now I'm kinda
> up against a deadline, but didn't want to leave it unreported. Should
> be easy for someone else to confirm or deny whether current tip has
> the problem.

FYI, I have created a bugzilla entry for this issue at:
http://bugzilla.kernel.org/show_bug.cgi?id=9568

Thanks,
Rafael
