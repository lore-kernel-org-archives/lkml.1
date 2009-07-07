Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZGGNAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZGGNAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZGGNAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:00:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZGGNAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:00:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5h8wj1argh.wl%tiwai@suse.de>
References: <s5h8wj1argh.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com> <s5hvdmos4i8.wl%tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
Date: Tue, 07 Jul 2009 14:00:06 +0100
Message-ID: <14931.1246971606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> The bug is still present on 2.6.31-rc2.

Yeah...  Sorry about that, I ran into another bug that was interfering with my
ability to test stuff, and so had to run that one down first...  And then
there was yet another bug - you know how it goes.

David
