Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZASKJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZASKJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZASKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:09:22 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:55170 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbZASKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:09:21 -0500
Date: Mon, 19 Jan 2009 11:09:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 22/85] [PATCH 02/44] [CVE-2009-0029] Convert all system
	calls to return a long
Message-ID: <20090119100916.GA4667@osiris.boeblingen.de.ibm.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115215938.GW17227@kroah.com> <20090118221723.GA3852@infradead.org> <20090118235053.GB18274@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118235053.GB18274@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 03:50:53PM -0800, Greg KH wrote:
> On Sun, Jan 18, 2009 at 05:17:23PM -0500, Christoph Hellwig wrote:
> > Umm, where was this whole stuff discussed?
> 
> I really have no idea, I'm assuming linux-arch?

It was discussed off-list with Linus, Andrew and all arch maintainers.
