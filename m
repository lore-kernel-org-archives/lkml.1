Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZFBGOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZFBGOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZFBGOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:14:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2755 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZFBGOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:14:16 -0400
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Matt Mackall <mpm@selenic.com>, Robin Getz <rgetz@blackfin.uclinux.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200906020059.18603.rob@landley.net>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
	 <1243885732.22069.112.camel@calx>  <200906020059.18603.rob@landley.net>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 23:10:58 -0700
Message-Id: <1243923058.3402.66.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 00:59 -0500, Rob Landley wrote:
> P.S.  I'd attach the 5 patch+descriptions, but I just spent fifteen minutes 
> fighting with git to try to convince "git log -p" that when I list a specific 
> commit on the command line I want it to spit out the description and patch for 
> JUST THAT ONE COMMIT and not log the history back to Grace Hopper's graduation 
> ceremony

git log -p -1 commit

git has a highly intelligent and consistent command-line interface...
damn, I forgot what the sarcasm argument is

