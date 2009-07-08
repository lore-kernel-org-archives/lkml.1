Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZGHMpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZGHMpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZGHMpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:45:31 -0400
Received: from mga12.intel.com ([143.182.124.36]:41803 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754311AbZGHMpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,368,1243839600"; 
   d="scan'208";a="162731657"
Date: Wed, 8 Jul 2009 14:43:37 +0100
From: Alan Cox <alan@linux.intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Erik Ekman <erik@kryo.se>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -tip][RFC] serial8250: update to dev_pm_ops
Message-ID: <20090708144337.7006fa0a@t61.ukuu.org.uk>
In-Reply-To: <200907081310.53579.elendil@planet.nl>
References: <20090701083737.41f28c7d.erik@kryo.se>
	<200907081310.53579.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009 13:10:51 +0200
Frans Pop <elendil@planet.nl> wrote:

> Adding some CCs as there's no reply yet.
> 
> > From dmesg:
> > Platform driver 'serial8250' needs updating - please use dev_pm_ops
> >
> > Is this how it should be done?
> 
> Alan or Rafael can probably tell.

No idea. I've not looked at this so your guess is as good as mine (but
looks quite believable. I don't plan to do anything until someone who
needs platform 8250 support sends a tested version of the change
however.

Alan
h
