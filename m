Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbXG1Jft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbXG1Jft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXG1Jfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:35:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbXG1Jfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:35:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AB0DDF.9000600@s5r6.in-berlin.de>
Date: Sat, 28 Jul 2007 11:35:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Daniel Cheng <gmane@sdiz.net>
CC: linux-kernel@vger.kernel.org, ck@vds.kolivas.org, linux-mm@kvack.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<46A57068.3070701@yahoo.com.au>	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	<46A58B49.3050508@yahoo.com.au>	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	<46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>	<1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>	<2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com> <20070725215717.df1d2eea.akpm@linux-foundation.org> <46AABB33.1080301@sdiz.net>
In-Reply-To: <46AABB33.1080301@sdiz.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Cheng wrote:
> but merging maps2 have higher risk which should be done in a development
> branch (er... 2.7, but we don't have it now).

This is off-topic and has been discussed to death, but:  Rather than one
stable branch and one development branch, we have a few stable branches
and a lot of development branches.  Some are located at git.kernel.org.
Among else, this gives you a predictable release rythm and very timely
updated stable branches.
-- 
Stefan Richter
-=====-=-=== -=== ===--
http://arcgraph.de/sr/
