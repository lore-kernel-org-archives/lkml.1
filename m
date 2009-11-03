Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZKCQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZKCQHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKCQHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:07:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:54527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZKCQHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:07:08 -0500
Date: Tue, 3 Nov 2009 17:07:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: "move stk17ta8's probe function to .devinit.text" considered
 trivial?
In-Reply-To: <20091103160451.GA21647@pengutronix.de>
Message-ID: <alpine.LSU.2.00.0911031705370.9988@wotan.suse.de>
References: <20091103160451.GA21647@pengutronix.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1188520309-1257264432=:9988"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1188520309-1257264432=:9988
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 3 Nov 2009, Uwe Kleine-König wrote:

> I just noticed that my patch
> 
> 	move stk17ta8's probe function to .devinit.text
> 
> is in your trivial queue (as c4fd30f9).  I'm happy that you took that,
> but I wonder if this is really trivial material considering that some of
> these patches were nacked.

This one was Acked by the maintainer of the driver, therefore it is OK to 
take it through trivial tree, see the trivial patch monkey guidelines in 
Documentation/SubmittingPatches.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-1188520309-1257264432=:9988--
