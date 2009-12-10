Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbZLJQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbZLJQpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760944AbZLJQpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:45:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57002 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752364AbZLJQph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:45:37 -0500
Date: Thu, 10 Dec 2009 16:47:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091210164718.6b0acb59@lxorguk.ukuu.org.uk>
In-Reply-To: <1260459601.18520.26.camel@skunk>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Last time they were asked that, they wanted to be free of changing their
> kernel/userspace interface before upstreaming.

So put it in staging with a note to that effect. That'll also get it more
exposure and review.

Alan
