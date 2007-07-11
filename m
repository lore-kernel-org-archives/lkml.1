Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbXGKU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbXGKU65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbXGKU6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:58:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763366AbXGKU6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:58:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 23:06:25 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111419.11418.rjw@sisk.pl> <200707112249.50363.nigel@nigel.suspend2.net>
In-Reply-To: <200707112249.50363.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112306.27041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 11 July 2007 14:49, Nigel Cunningham wrote:
> Hi.
> 
> On Wednesday 11 July 2007 22:19:10 Rafael J. Wysocki wrote:
> > The sync probably slows down more than the freezing itself ...
> 
> Absolutely. Waaaay more. Maybe it would help if you popped in some printks 
> that help people see that it's not the freezer taking a long time, but 
> syncing?

In a while, I'll be posting a freezer update to linux-pm.  It contains
something like this among other things.  Please have a look.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
