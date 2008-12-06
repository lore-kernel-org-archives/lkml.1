Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYLFAg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYLFAg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYLFAgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:36:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:55888 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbYLFAgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:36:03 -0500
Date: Fri, 5 Dec 2008 16:26:43 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@suse.cz>
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
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 062/104] ACPI: EC: count interrupts only if called from
	interrupt handler.
Message-ID: <20081206002643.GB11240@suse.de>
References: <20081203193901.715896543@mini.kroah.org> <20081203195300.GK8950@kroah.com> <20081205130649.GB1750@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205130649.GB1750@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 02:06:49PM +0100, Pavel Machek wrote:
> On Wed 2008-12-03 11:53:00, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Alexey Starikovskiy <astarikovskiy@suse.de>
> > 
> > commit 7b4d469228a92a00e412675817cedd60133de38a upstream.
> > 
> > fix 2.6.28 EC interrupt storm regression
> > 
> 
> That changelog is pretty useless :-(.

That is the identical changelog from upstream.

thanks,

greg k-h
