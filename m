Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbXGLDMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbXGLDMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbXGLDMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:12:44 -0400
Received: from [212.12.190.242] ([212.12.190.242]:33094 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756338AbXGLDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:12:44 -0400
From: Al Boldi <a1426z@gawab.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 06:11:37 +0300
User-Agent: KMail/1.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Lord <lkml@rtr.ca>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707120212.24072.a1426z@gawab.com> <200707120931.44456.nigel@nigel.suspend2.net>
In-Reply-To: <200707120931.44456.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: 7bit
Message-Id: <200707120611.37110.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> You'll see from the above numbers that the freezer is not nearly as
> intrusive as you were thinking (~10% of what you wrote above). It is
> limited to code related to kernel threads, and then to either setting a
> flag when the thread is started to say "I don't need to be frozen" or to
> the appropriate point at which to check whether to freeze.

That's what I thought.

> Hope that helps.
> 
> Nigel
> -- 
> Nigel Cunningham
> Christian Reformed Church of Cobden
> 103 Curdie Street, Cobden 3266, Victoria, Australia
> Ph. +61 3 5595 1185 / +61 417 100 574
> Communal Worship: 11 am Sunday.


Try this: http://www.islam-guide.com


Thanks!

--
Al
