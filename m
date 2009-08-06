Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZHFXw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZHFXw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZHFXw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:52:58 -0400
Received: from vena.lwn.net ([206.168.112.25]:39258 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbZHFXw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:52:57 -0400
Date: Thu, 6 Aug 2009 17:50:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jon Masters <jonathan@jonmasters.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [OT] LWN not resolving
Message-ID: <20090806175008.31987340@bike.lwn.net>
In-Reply-To: <1249590763.8924.57.camel@perihelion.bos.jonmasters.org>
References: <1249590763.8924.57.camel@perihelion.bos.jonmasters.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Aug 2009 16:32:43 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> Just a head's up in case Jon is reading this and for some bizaare reason
> doesn't know already, LWN is currently not resolving.

Trust me, I knew.  Primary DNS went away when our local colo fell off
the net (conveniently taking my DSL with it).  That's when we found out
that the bind update from <insert on-shitlist distributor name here>
caused zone transfers to start failing (silently) a couple of months
ago, so the secondary refused to do its thing.

Back now.

Thanks,

jon
