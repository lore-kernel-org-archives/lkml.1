Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXH0KQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXH0KQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 06:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXH0KQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 06:16:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45276 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXH0KQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 06:16:24 -0400
Date: Mon, 27 Aug 2007 12:17:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bjoern Boschman <bjoern@boschman.de>
Cc: linux-kernel@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: oracleasm driver into mainline?
Message-ID: <20070827101743.GA19249@uranus.ravnborg.org>
References: <46D1E0E7.4090806@boschman.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D1E0E7.4090806@boschman.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2007 at 10:21:59PM +0200, Bjoern Boschman wrote:
> Hi,
> 
> I just wanted to ask if there might be a possibility that the oracleasm
> kernel driver could find its way into the mainline kernel?

Your mail is sent "To:" linux-kernel but the right thing is to ask Oracle.
If Oracle want's to submit the driver for inclusion in the mainline
kernel then they know they have to put some effort into doing so.
The normal steps are:
-> Prepare patch set including a good description of what the driver does and
   notes about how it does so and sentd it to relevant lists.
-> Address trivial comments from the coding style police
-> Address design related comments such as "do not abuse proc filesystem"
-> Resend the patch-set a few times ro more.

All in all a timeconsuming task and the resulting driver may not be fully
compatible with the original driver due to the design issues.

Anyone can do the above work but this just need to be done to get it included.

	Sam
