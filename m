Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXGEUzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXGEUzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760809AbXGEUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:55:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:47338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760356AbXGEUz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:55:26 -0400
Date: Thu, 5 Jul 2007 22:55:24 +0200
From: Bernhard Walle <bwalle@suse.de>
To: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070705205523.GA15202@suse.de>
Mail-Followup-To: List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it> <8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz> <20070705192002.GB11204@DervishD> <87vecyeg5y.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vecyeg5y.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nix <nix@esperi.org.uk> [2007-07-05 22:42]:
> 
> My only real grouch with cmake is that the authors have invented a
> language with so bloody many capital letters in it. 

The real problem I see with cmake is that you need to have cmake
installed on the build system. While cmake itself isn't the problem,
often, it also depends on the version of cmake that is installed. The
good idea about auto* tools is the idea that you don't need to install
any tools to build, just to develop. A POSIX shell and Perl should be
installed everywhere ...

Maybe the problem becomes less important in a few years if everyone
has cmake installed and it's more "stable" in terms of adding new
features.



Thanks,
   Bernhard
