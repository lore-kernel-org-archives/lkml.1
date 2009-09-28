Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZI1D36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZI1D36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZI1D36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:29:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZI1D35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:29:57 -0400
Date: Sun, 27 Sep 2009 23:29:56 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: John David Anglin <dave.anglin@nrc-cnrc.gc.ca>
Cc: Julia Lawall <julia@diku.dk>, Helge Deller <deller@gmx.de>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/parisc: correct use of SHF_ALLOC
Message-ID: <20090928032956.GN11961@bombadil.infradead.org>
References: <Pine.LNX.4.64.0908042226231.3737@ask.diku.dk> <20090927182149.GA23464@hiauly1.hia.nrc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927182149.GA23464@hiauly1.hia.nrc.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 02:21:50PM -0400, John David Anglin wrote:
> Hi Kyle,
> 
> I noticed today that this change is not in 2.6.31.1.
> 

Dunno what happened... I must have updated patchwork and missed it in a
rebase locally.
