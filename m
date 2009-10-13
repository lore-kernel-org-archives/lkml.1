Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbZJMIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbZJMIur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759102AbZJMIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:50:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33259 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZJMIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:50:46 -0400
Date: Tue, 13 Oct 2009 10:50:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Nelson Elhage <nelhage@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] arm: Clean up linker script using new linker
	script macros.
Message-ID: <20091013085003.GB3194@pengutronix.de>
References: <alpine.DEB.1.10.0910021536510.19358@dr-wily.mit.edu> <1254515567-27110-2-git-send-email-tabbott@ksplice.com> <alpine.DEB.1.10.0910121036130.6253@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.1.10.0910121036130.6253@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:41:10AM -0400, Tim Abbott wrote:
> Can someone with an arm machine test this patch?  I'd really appreciate 
> it.
Compiles and is running fine on eco920.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
