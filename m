Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYJXXBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYJXXBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYJXXBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:01:01 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44812 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYJXXBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:01:00 -0400
Date: Sat, 25 Oct 2008 01:00:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27: add patch for ALPS touchpad on Latitude E6[45]00
In-Reply-To: <200810250026.50026.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0810250059400.22126@twin.jikos.cz>
References: <pan.2008.10.11.15.33.28@telenet.be> <200810250026.50026.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:

> > I need to add this patch to the 2.6.27 kernel to have my touchpad detected 
> > correctly on my Latitude E6400 laptop. Is it possible to apply this to 
> > 2.6.27 stable?
> > http://lkml.org/lkml/2008/9/7/133
> Did 2.6.26 work for you correctly without this patch?

It hardly could, the driver simply didn't support the model in question.

-- 
Jiri Kosina
SUSE Labs

