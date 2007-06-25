Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXFYGiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXFYGiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXFYGiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:38:14 -0400
Received: from mx10.go2.pl ([193.17.41.74]:36994 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753783AbXFYGiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:38:13 -0400
Date: Mon, 25 Jun 2007 08:45:59 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, cebbert@redhat.com,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070625064559.GA1680@ff.dom.local>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621201624.GD22303@elte.hu> <20070622081702.GA14746@elte.hu> <E1I22yO-0004TX-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I22yO-0004TX-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:36:08PM +0200, Miklos Szeredi wrote:
...
> And it's not a NO_HZ kernel.
...

BTW, maybe I've missed this and it's unconnected, but I hope the
first config has been changed - especially this CONFIG_AGP_AMD64 = y,
and this bug from mm/slab.c has gone long ago...

Jarek P.
