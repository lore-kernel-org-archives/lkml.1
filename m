Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbXKGWCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbXKGWCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXKGWC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:02:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238AbXKGWCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:02:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH (2.6.25) 0/2] suspend/hibernate Kconfig cleanups
Date: Wed, 7 Nov 2007 23:17:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071107135758.100171000@sipsolutions.net>
In-Reply-To: <20071107135758.100171000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711072317.48023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of November 2007, Johannes Berg wrote:
> These two patches, intended for 2.6.25, clean up the
> suspend/hibernate Kconfig.

Both patches look good.

Since they touch a couple of architectures, I think it's better to merge them
through -mm.

Greetings,
Rafael
