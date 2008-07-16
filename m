Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYGPPfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYGPPfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbYGPPfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:35:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741AbYGPPfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:35:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: s2disk: system powers up again after power off
Date: Wed, 16 Jul 2008 17:37:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
References: <20080715124733.GA4111@deprecation.cyrius.com> <200807152224.19559.rjw@sisk.pl> <20080716123611.GA2532@deprecation.cyrius.com>
In-Reply-To: <20080716123611.GA2532@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161737.12370.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of July 2008, Martin Michlmayr wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-07-15 22:24]:
> > Please try to put "shutdown method = shutdown" into the s2disk's configuration
> > file and see what happens in that case.
> 
> Yep, this work.

This is a workaround, though.

Can you check if the problem is present in linux-next, please?

Rafael
