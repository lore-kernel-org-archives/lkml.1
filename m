Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYBRKP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYBRKP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYBRKPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:15:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbYBRKPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:15:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Date: Mon, 18 Feb 2008 11:13:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080218002815.GA4612@dose.home.local>
In-Reply-To: <20080218002815.GA4612@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181113.37613.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Tino Keitel wrote:
> Hi folks,
> 
> with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> message on the console is "Suspending console(s)". I also tried some
> other versions after 2.6.24, all of them fail with this hang.
> 
> I attached the lspci output for the case that it matters.

Please open a Bugzilla entry for this problem.  We'll investigate it using
the Bugzilla.

Thanks,
Rafael
