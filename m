Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbXBKSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbXBKSzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXBKSzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:55:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXBKSzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:55:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 19:31:21 +0100
User-Agent: KMail/1.9.5
Cc: "Willy Tarreau" <w@1wt.eu>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Daniel Barkalow" <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111536.20871.rjw@sisk.pl> <84144f020702110719i27718657s4c74a4f7217cce6@mail.gmail.com>
In-Reply-To: <84144f020702110719i27718657s4c74a4f7217cce6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111931.23135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 16:19, Pekka Enberg wrote:
> On 2/11/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Unfortunately it has to be done in one shot for all of the known good drivers to avoid
> > user-observable regressions.
> 
> No you don't. You can make it a config option that defaults to n
> during a transition period.

Yes, that's possible.

Greetings,
Rafael
