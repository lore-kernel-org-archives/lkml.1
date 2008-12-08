Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbYLHSra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbYLHSra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLHSrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:47:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYLHSrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:47:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Date: Mon, 8 Dec 2008 19:46:49 +0100
User-Agent: KMail/1.9.9
Cc: Holger Hoffstaette <holger@wizards.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, stable@kernel.org
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <493D4C1B.4030006@s5r6.in-berlin.de>
In-Reply-To: <493D4C1B.4030006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081946.50295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > Please bisect.
> 
> Why should he bisect before the developers who added networking related
> patches to .8 attempted to reproduce the bug, let alone looked at the
> report?

Because I think that's the fastest way to turn the attention of the appropriate
people to the problem.

Thanks,
Rafael
