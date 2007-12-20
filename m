Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbXLTWJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbXLTWJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764067AbXLTWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:08:28 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1906 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764082AbXLTWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:08:26 -0500
Subject: Re: Trailing periods in kernel messages
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, apw@shadowen.org, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
In-Reply-To: <20071220.135133.262055434.davem@davemloft.net>
References: <1196390128.22120.118.camel@localhost>
	 <20071220162923.GB27885@shadowen.org>
	 <20071220210741.6dc3caf5@the-village.bc.nu>
	 <20071220.135133.262055434.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 14:07:48 -0800
Message-Id: <1198188468.6183.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 13:51 -0800, David Miller wrote:
> > The kernel printk messages are sentences. English language sentences end
> > with a full stop. They are messages printed up for normal human beings to
> > read and they should therefore be properly written.
> I totally agree.
> I think the incorrect grammar and lack of proper capitalization and
> puntuation in the kernel messages and our changelog entries is totally
> embarassing for a professional software project.

I agree with the grammar, capitalization, punctuation desires.
I add spelling, intelligibility and consistency to that list.

I believe though that printk messages are not sentences but are
logging statements.  Statements do not require full-stops.

Opinions, of course, vary.

cheers, Joe

