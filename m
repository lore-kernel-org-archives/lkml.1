Return-Path: <linux-kernel-owner+w=401wt.eu-S937878AbYBWA4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937878AbYBWA4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937761AbYBWAy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:54:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937760AbYBWAy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:54:57 -0500
Date: Fri, 22 Feb 2008 16:53:49 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 34/38] kbuild: allow -fstack-protector to take effect
Message-ID: <20080223005349.GA30744@suse.de>
References: <20080223001946.979768610@mini.kroah.org> <20080223003133.GI7268@suse.de> <20080222164617.50c8ec2e@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222164617.50c8ec2e@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 04:46:17PM -0800, Arjan van de Ven wrote:
> On Fri, 22 Feb 2008 16:31:33 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.24-stable review patch.  If anyone has any objections, please let
> > us know.
> 
> 
> not ready for -stable yet. if ever for backporting (doubtful)

Ok, dropped from -stable, thanks.

greg k-h
