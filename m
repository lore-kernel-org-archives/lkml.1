Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYJXXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYJXXEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYJXXER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:04:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYJXXER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:04:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.27: add patch for ALPS touchpad on Latitude E6[45]00
Date: Sat, 25 Oct 2008 01:08:47 +0200
User-Agent: KMail/1.9.9
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
References: <pan.2008.10.11.15.33.28@telenet.be> <200810250026.50026.rjw@sisk.pl> <Pine.LNX.4.64.0810250059400.22126@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0810250059400.22126@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250108.47639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Jiri Kosina wrote:
> On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> 
> > > I need to add this patch to the 2.6.27 kernel to have my touchpad detected 
> > > correctly on my Latitude E6400 laptop. Is it possible to apply this to 
> > > 2.6.27 stable?
> > > http://lkml.org/lkml/2008/9/7/133
> > Did 2.6.26 work for you correctly without this patch?
> 
> It hardly could, the driver simply didn't support the model in question.

Ah, sorry, should have looked at the patch more carefully.

Thanks,
Rafael
