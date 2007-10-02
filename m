Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbXJBDWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbXJBDWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 23:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJBDWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 23:22:46 -0400
Received: from usul.saidi.cx ([204.11.33.34]:58716 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbXJBDWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 23:22:45 -0400
Message-ID: <4701B97D.8070807@overt.org>
Date: Mon, 01 Oct 2007 20:22:37 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: sdhci-devel@list.drzeus.cx, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
References: <46EC3860.3070600@overt.org>	<20070920182429.247b28fb@poseidon.drzeus.cx>	<46F3D5A3.1070201@overt.org> <20070921185705.3602fb0e@poseidon.drzeus.cx>
In-Reply-To: <20070921185705.3602fb0e@poseidon.drzeus.cx>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> 
> Preferably. But if you can't figure it out until it is time to merge
> things upstream, then I'll go with what we have right now.

I have not been contacted by anyone with one of those laptops so I
haven't been able to find out what's going on.

I'm updating the diff, because I forgot to terminate the pci table,
so it didn't add the alias correctly.

--phil
