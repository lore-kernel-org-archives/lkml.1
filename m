Return-Path: <linux-kernel-owner+w=401wt.eu-S936203AbXJPX3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936203AbXJPX3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760961AbXJPX3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:29:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38314
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbXJPX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:29:22 -0400
Date: Tue, 16 Oct 2007 16:29:27 -0700 (PDT)
Message-Id: <20071016.162927.116354214.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl, perex@perex.cz
Subject: Re: suspicious ALSA empty commit
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
References: <20071016.155044.82377336.davem@davemloft.net>
	<alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Oct 2007 16:26:43 -0700 (PDT)

> Git shouldn't even allow such commits to be generated, although you can 
> force it by using the low-level functionality (eg using "git commit-tree" 
> directly for doing things like importing)

That would be useful, I think it is a common error when
importing and exporting patches.
