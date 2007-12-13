Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbXLMQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbXLMQno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbXLMQnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:43:16 -0500
Received: from ns.suse.de ([195.135.220.2]:37736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbXLMQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:43:15 -0500
Date: Thu, 13 Dec 2007 08:38:46 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 09/60] Input: ALPS - add signature for ThinkPad R61
Message-ID: <20071213163846.GA10429@suse.de>
References: <20071213064518.328162328@mini.kroah.org> <20071213065039.GA6867@kroah.com> <20071213065127.GJ6867@kroah.com> <d120d5000712130541x13a645e0x7f2f3b31d80e1f35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000712130541x13a645e0x7f2f3b31d80e1f35@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:41:20AM -0500, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Dec 13, 2007 1:51 AM, Greg KH <gregkh@suse.de> wrote:
> > 2.6.23-stable review patch.  If anyone has any objections, please let us
> > know.
> >
> > ------------------
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> > changeset f493018ebc3f94d64e12bc848db0906700bf73a2 in mainline.
> >
> > Input: ALPS - add signature for ThinkPad R61
> >
> 
> Please drop this one... I think I have seen a report where it
> interferes with a regular logitech mouse. I will see if I fix it for
> .24 or revert if from mainline. Definitely not for stable.

Thanks for letting me know, I've now dropped it.

greg k-h
