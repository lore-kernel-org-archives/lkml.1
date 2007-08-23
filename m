Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbXHWDrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbXHWDrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXHWDrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:47:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59317 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbXHWDrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:47:24 -0400
Date: Wed, 22 Aug 2007 20:45:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Hardwick <p.hardwick@option.com>
Subject: Re: drivers/char/nozomi.c - compile error ( Re: 2.6.23-rc3-mm1 )
Message-Id: <20070822204555.b7d23375.randy.dunlap@oracle.com>
In-Reply-To: <46CCC716.1080708@googlemail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CCC716.1080708@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 01:30:30 +0200 Gabriel C wrote:

> 
> config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-18
> 
> ...
> 
> drivers/char/nozomi.c:2204: error: expected expression before '__attribute__'

__devexit should be __devexit_p


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
