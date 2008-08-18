Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYHRMav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYHRMav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYHRMaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:30:20 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3096 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbYHRMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:30:17 -0400
Date: Mon, 18 Aug 2008 06:30:16 -0600
From: Alex Chiang <achiang@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: tty-kref-modcount oops in linux-next
Message-ID: <20080818123016.GA2537@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080813203438.GT25902@ldl.fc.hp.com> <20080813213348.68263ad7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813213348.68263ad7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Wed, 13 Aug 2008 14:34:38 -0600
> Alex Chiang <achiang@hp.com> wrote:
> > 
> > Booting the latest linux-next kernel (20080812) on my HP rx6600
> > (ia64) results in an oops. This is a SLES10 userspace, but I
> > don't know if that matters.
> 
> Thanks I pushed a few fixes into the ttydev tree today so hopefully they
> are fixed, if not drop me another email and we'll work through your case
> as well

Thanks, the latest linux-next (20080818) boots just fine now.

/ac

