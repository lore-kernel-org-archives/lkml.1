Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXE2L4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXE2L4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXE2L4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXE2L4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:56:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Tue, 29 May 2007 14:01:59 +0200
User-Agent: KMail/1.9.5
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200705261128.57332.maxi@daemonizer.de> <200705282021.30355.rjw@sisk.pl> <20070529003959.GA32543@gondor.apana.org.au>
In-Reply-To: <20070529003959.GA32543@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291402.01757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 02:39, Herbert Xu wrote:
> On Mon, May 28, 2007 at 08:21:29PM +0200, Rafael J. Wysocki wrote:
> >
> > Well, it looks like we have to fix this one separately.
> > 
> > Can you please tell me what to do to make cryptd run?
> 
> If you build it as a module then just loading it should be sufficient.
> If you have it built-in then it should always be there.

Thanks.

> Let me know when you guys have a final patch.

OK

Greetings,
Rafael
