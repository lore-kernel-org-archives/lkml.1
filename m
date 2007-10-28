Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXJ1XDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXJ1XDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXJ1XD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:03:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXJ1XD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:03:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Date: Mon, 29 Oct 2007 00:19:56 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <200710282351.56284.rjw@sisk.pl> <E1ImGvo-0006bE-Tr@faramir.fjphome.nl>
In-Reply-To: <E1ImGvo-0006bE-Tr@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710290019.56862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 23:48, Frans Pop wrote:
> The regression in process CPU usage display in top is still there:
> http://bugzilla.kernel.org/show_bug.cgi?id=9135
> 
> It's a regression from .22, not from .23, but I guess it should still be
> listed.

Well, my intention is to list the most recent regressions in these messages.

Your regression is in the bugzilla, is marked as a regression and linked
to the appropriate meta bug entry ...

Well, perhaps I'll be able to send a "post 2.6.22 regressions" message with a
longer list from time to time, but I can't promise that.

Greetings,
Rafael
