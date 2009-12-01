Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZLAHLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZLAHLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZLAHLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:11:21 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:34153 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZLAHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:11:18 -0500
Subject: Re: [PATCH] param: don't complain about unused module parameters.
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adam Williamson <awilliam@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200912011456.44457.rusty@rustcorp.com.au>
References: <200912011456.44457.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 01 Dec 2009 02:11:08 -0500
Message-Id: <1259651468.6978.95.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 14:56 +1030, Rusty Russell wrote:
> Jon confirms that recent modprobe will look in /proc/cmdline, so these
> cmdline options can still be used.

Yup. Thanks for that.

Jon.


