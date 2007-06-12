Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXFLPs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXFLPs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXFLPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:48:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbXFLPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:48:51 -0400
Date: Tue, 12 Jun 2007 17:48:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070612154848.GA23367@one.firstfloor.org>
References: <200706071530.51552.jesse.barnes@intel.com> <20070612145007.GA5986@ucw.cz> <200706120829.21465.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706120829.21465.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
> > you drop the stars and stop shouting?
> 
> How missing about 1G of memory?  We already discussed this, and Andi and 
> Venki felt that either a panic or a really obnoxious message was the 
> way to go...

Perhaps you could vary the number of stars based on the missing amount 
to satisfy Pavel @)

-Andi
