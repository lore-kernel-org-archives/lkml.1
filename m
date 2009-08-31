Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZHaE6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZHaE6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZHaE6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:58:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52433 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZHaE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:58:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Documentation/vm/.gitignore: Add page-types
Cc: kosaki.motohiro@jp.fujitsu.com, Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090812065107.GA16363@localhost>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost>
Message-Id: <20090831135720.5E53.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 31 Aug 2009 13:58:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Josh,
> 
> Good catch, thanks.
> 
> btw, maybe we can move page-types into the newly created tools/ dir?

I agree.
btw, I think slabinfo can move into it too.



