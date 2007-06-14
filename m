Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbXFNMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbXFNMaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXFNMan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:30:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbXFNMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:30:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Thu, 14 Jun 2007 14:37:15 +0200
User-Agent: KMail/1.9.5
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com> <200706140010.03438.dtor@insightbb.com>
In-Reply-To: <200706140010.03438.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141437.16267.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 06:10, Dmitry Torokhov wrote:
> On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > Dmitry, you added this recently, is this used in any code you plan to
> > merge soon?
> >
> 
> Yes, I will need it to implement input device resume (mainly to restore LED
> state and repeat rate for keyboards).

Would that be a big problem to reintroduce it along with the user?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
