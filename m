Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYFYJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYFYJH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYFYJHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:07:49 -0400
Received: from [194.117.236.238] ([194.117.236.238]:32798 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYFYJHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:07:48 -0400
Date: Wed, 25 Jun 2008 12:07:27 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface,
 remove old interface.
Message-ID: <20080625120727.42867627@linux360.ro>
In-Reply-To: <20080625120151.56180b47@linux360.ro>
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
	<20080625120151.56180b47@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please merge this instead, it's based on linux-next. Your change wasn't
enough.

And I don't think Tom Zanussi should be Cc-ed on patches 1 and 2, these
are mere prereqs for the 3rd. So add the Cc for Tom just for the third.
You could add yourself as Cc to the other two, or whoever you think is
responsible for such core stuff.


	Cheers,
	Eduard
