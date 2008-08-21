Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYHUPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYHUPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbYHUPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:13:08 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:37925 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbYHUPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:13:07 -0400
Message-ID: <48AD8600.3030109@dgreaves.com>
Date: Thu, 21 Aug 2008 16:13:04 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808211447.35284.rjw@sisk.pl>
In-Reply-To: <200808211447.35284.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Please try 2.6.26.x and see if the problem is present in there.
I'm pretty sure it is - it's my wife's machine and she's been stable on 2.6.25
for a while. I moved to 2.6.26 to fix a CDROM problem and I think that was when
I encountered this. IIRC I then tried 2.6.27-rcX to see if it had been fixed and
here we are...

I'll confirm tomorrow morning.

I wrote first in case there was any debug/instrumentation worth configuring in
as I have plenty time to recompile a kernel before shutting down tonight.

David

