Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYJWWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYJWWCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYJWWB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:01:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYJWWB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:01:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius <nico-linux-next@schottelius.org>
Subject: Re: Current suspend issues on Lenovo X200
Date: Fri, 24 Oct 2008 00:06:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <20081023210707.GA5089@denkbrett.schottelius.org>
In-Reply-To: <20081023210707.GA5089@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240006.19857.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 23 of October 2008, Nico Schottelius wrote:
> First of all, this was wrong:
> 
> Nico -telmich- Schottelius [Thu, Oct 23, 2008 at 10:43:26PM +0200]:
> >  - 2.6.27: system freeze instead of wakeup
> >    -> shows parts of the X screen, but does not react on ping
> 
> System does not freeze, but reboots instead.
> 
> Tried next-20081023 and 2.6.27 with acpi_sleep=s3_bios:
> 
> - suspend and wakeup on console works fine for both!
> - no X running on next
> - 2.6.27 + X -> reboot on wakeup

Let me guess, you have a NVidia graphics?

Rafael
