Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbXKBR57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbXKBR57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXKBR5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:57:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:38257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbXKBR5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:57:52 -0400
Date: Fri, 2 Nov 2007 18:57:50 +0100
From: Jan Blunck <jblunck@suse.de>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 6/7] d_path: Make d_path() use a struct path
Message-ID: <20071102175749.GA5619@hasse.suse.de>
References: <20071029124120.528997881@weierstrass.suse.de> <20071029124121.829255433@weierstrass.suse.de> <344eb09a0711012345p1d6bd667s52ef38f3185b478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <344eb09a0711012345p1d6bd667s52ef38f3185b478@mail.gmail.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, Bharata B Rao wrote:

> 
> Did you miss the d_path() caller arch/blackfin/kernel/traps.c:printk_address() ?
> 

Sorry, yes I missed that one.
