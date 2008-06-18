Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYFRNh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYFRNh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYFRNhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:37:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYFRNhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:37:18 -0400
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
From: David Woodhouse <dwmw2@infradead.org>
To: Erik Mouw <mouw@nl.linux.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Pierre Ossman <drzeus@drzeus.cx>,
       Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20080618133530.GG6788@gateway.home>
References: <483FE9E7.7020707@atmel.com>
	 <20080609124623.5b6bda48@mjolnir.drzeus.cx> <484E4F61.7010007@atmel.com>
	 <20080614182831.0360bd77@mjolnir.drzeus.cx> <4858DDC1.6080802@atmel.com>
	 <20080618104723.GA6788@gateway.home> <20080618111607.GB6788@gateway.home>
	 <20080618114057.GE2226@local>
	 <1213789670.26255.1200.camel@pmac.infradead.org>
	 <20080618133530.GG6788@gateway.home>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 14:37:05 +0100
Message-Id: <1213796225.26255.1237.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 15:35 +0200, Erik Mouw wrote:
> Oh well, rmk isn't available for a few days so I can't really debug the
> Mailman version on lists.arm.linux.org.uk :(

I can set up a test list for you to screw around with if you like.

-- 
dwmw2

