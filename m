Return-Path: <linux-kernel-owner+w=401wt.eu-S1422902AbXBHCcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422902AbXBHCcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422904AbXBHCcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:32:32 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41996 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422902AbXBHCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:32:32 -0500
X-Sasl-enc: PSTGVNdjwdYtVasVjMZ1lax8m+chIErcAc1seSC0ArYA 1170901949
Subject: Re: [autofs] Bad race condition in the new autofs protocol
	somewhere
From: Ian Kent <raven@themaw.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <20070207181817.GA75717@dspnet.fr.eu.org>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 11:33:10 +0900
Message-Id: <1170901990.3383.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 19:18 +0100, Olivier Galibert wrote:
> On Thu, Feb 08, 2007 at 03:07:41AM +0900, Ian Kent wrote:
> > It may be better to update to a later kernel so I don't have to port the
> > patch to several different kernels. Is that possible?
> 
> Sure, 2.6.20 or -git?

2.6.20 has all the patches I've proposed so far except for the one we're
working on so that would be best for me.

Seems there may still be a problem with the patch so I'll let you know
what's happening as soon as I can.

Ian


