Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZCNMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZCNMwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZCNMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 08:52:21 -0400
Received: from verein.lst.de ([213.95.11.210]:54908 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZCNMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 08:52:21 -0400
Date: Sat, 14 Mar 2009 13:46:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 07/96] documnt FMODE_ constants
Message-ID: <20090314124620.GA23968@lst.de>
References: <20090314000508.803142980@mini.kroah.org> <20090314000739.667137229@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314000739.667137229@mini.kroah.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 05:05:15PM -0700, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us kno

Why would you even consider this for stable?  It's purely documenting
a couple of constants.

