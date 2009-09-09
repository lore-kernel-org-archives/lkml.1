Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZIIOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZIIOqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZIIOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:46:47 -0400
Received: from fifo99.com ([67.223.236.141]:47906 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZIIOqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:46:46 -0400
Subject: Re: [patch] zaurus family: battery cleanups
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20090909073904.GE1327@ucw.cz>
References: <20090909073904.GE1327@ucw.cz>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 07:47:11 -0700
Message-Id: <1252507631.14793.113.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:39 +0200, Pavel Machek wrote:
> This cleans up battery code to conform to codingstyle. The only real
> change is that we should now refuse to charge if we can't read battery
> temperature.

This patch has a number of checkpatch errors. Mostly trailing
whitespace, or just spacing issues..

Daniel

