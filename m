Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZARXyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZARXyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZARXyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:54:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZARXyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:54:03 -0500
Date: Sun, 18 Jan 2009 15:50:53 -0800
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 22/85] [PATCH 02/44] [CVE-2009-0029] Convert all system
	calls to return a long
Message-ID: <20090118235053.GB18274@suse.de>
References: <20090115215237.906089480@mini.kroah.org> <20090115215938.GW17227@kroah.com> <20090118221723.GA3852@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118221723.GA3852@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 05:17:23PM -0500, Christoph Hellwig wrote:
> Umm, where was this whole stuff discussed?

I really have no idea, I'm assuming linux-arch?
