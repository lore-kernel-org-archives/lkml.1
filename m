Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYEECvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYEECvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYEECvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:51:44 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3114 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYEECvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:51:43 -0400
Subject: Re: [PATCH -mm] __ratelimit rewrite
From: Joe Perches <joe@perches.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0805041837q4a5264c6l7bc23dce1d3282fd@mail.gmail.com>
References: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
	 <1209912447.16966.42.camel@localhost>
	 <a8e1da0805041837q4a5264c6l7bc23dce1d3282fd@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 04 May 2008 19:25:05 -0700
Message-Id: <1209954305.13011.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 09:37 +0800, Dave Young wrote:
> >  I think your changes should then be done in
> >  printk.h not creating a new ratelimit.h.
> 
> IMO ratelimit is not just for printk use now, so a standalone head
> file is necessary.

What other uses would ratelimit have?

