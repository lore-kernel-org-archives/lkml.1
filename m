Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYFXVMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYFXVMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYFXVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:11:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYFXVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:11:53 -0400
Date: Tue, 24 Jun 2008 14:07:35 -0700
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch 06/10] Add return value to reserve_bootmem_node()
Message-ID: <20080624210735.GA3694@suse.de>
References: <20080623225737.837265824@mini.kroah.org> <20080623230458.GF29853@suse.de> <20080624110601.GA16021@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624110601.GA16021@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 02:06:01PM +0300, Adrian Bunk wrote:
> Hi Greg,
> 
> can you put this patch in front of patch 4
> (x86: use BOOTMEM_EXCLUSIVE on 32-bit) in the
> series file for working bisecting of 2.6.25.y ?

Thanks for noticing, I've now done that.

greg k-h
