Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZFVPVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZFVPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFVPVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:21:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVPVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:21:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hvdmos4i8.wl%tiwai@suse.de>
References: <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
Date: Mon, 22 Jun 2009 16:21:32 +0100
Message-ID: <4360.1245684092@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> The log is below.  FWIW, it's on ext3.

This is with that patch?

David
