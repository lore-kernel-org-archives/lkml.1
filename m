Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYBTHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYBTHt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYBTHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:49:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:53802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYBTHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:49:18 -0500
Message-ID: <47BBDB6E.5040109@suse.de>
Date: Wed, 20 Feb 2008 08:49:02 +0100
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 20
References: <20080220163457.79b9189f.sfr@canb.auug.org.au>	<20080220055055.GC31832@kroah.com> <20080220175756.ab1ada1d.sfr@canb.auug.org.au>
In-Reply-To: <20080220175756.ab1ada1d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> That would work.  Chris has the right idea, though.  Just set up
> linux-next as a remote on any existing clone of Linus' tree and the
> "fetch" will forcibly update the linux-next/master branch (remember to
> not have that branch checked out when you fetch).
> 
> If you keep a continuing git tree for this, you will have the history of
> all the next trees because I tag each one.

Thanks for that hint. Added it to the FAQ on the Wiki
(http://linux.f-seidel.de/linux-next/pmwiki/).

Frank
