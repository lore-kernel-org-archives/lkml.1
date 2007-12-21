Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbXLUAFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbXLUAFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbXLUAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:04:54 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1980 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbXLUAEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:04:53 -0500
Subject: Re: Trailing periods in kernel messages
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, apw@shadowen.org, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
In-Reply-To: <20071220220853.4f7c639c@the-village.bc.nu>
References: <1196390128.22120.118.camel@localhost>
	 <20071220162923.GB27885@shadowen.org>
	 <20071220210741.6dc3caf5@the-village.bc.nu>
	 <20071220.135133.262055434.davem@davemloft.net>
	 <1198188468.6183.80.camel@localhost>
	 <20071220220853.4f7c639c@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 16:04:10 -0800
Message-Id: <1198195451.6183.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 22:08 +0000, Alan Cox wrote:
> I do not believe "opinions" are relevant here. Relevant would be cites
> from respected style guides (Fowlers, Oxford Guide To Style et al.) to
> show they do not need a full stop. 
> I've not found one, but I am open to references.

What exactly is a guide other than an opinion?
I believe log entries are not exactly literature.
How does Fowler's applies to logs?

Other opinions/guides:

For:
http://nedbatchelder.com/text/log-style-guide.html
(though note the use of "good examples" without periods)

Against: (in lists)
http://home.comcast.net/~garbl/stylemanual/kthrul.htm

cheers, Joe

