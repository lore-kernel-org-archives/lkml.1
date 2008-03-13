Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYCMCiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYCMCiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 22:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYCMCiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 22:38:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36393 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYCMCiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 22:38:02 -0400
Message-ID: <47D8936B.3020501@garzik.org>
Date: Wed, 12 Mar 2008 22:37:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       =?UTF-8?B?TGluYXMgxb12aXJibGlz?= <0x0007@gmail.com>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
References: <200803120141.51844.rjw@sisk.pl> <20080312194035.GA23482@dose.home.local> <200803122328.19285.rjw@sisk.pl>
In-Reply-To: <200803122328.19285.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following regression fix is now upstream...



Commit:     f9e7d100ddea5cdcea7a02230566f36b0a648c2e

     FIXED_PHY must depend on PHYLIB=y
