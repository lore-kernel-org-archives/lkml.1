Return-Path: <linux-kernel-owner+w=401wt.eu-S1763043AbYFWTcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763043AbYFWTcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762902AbYFWTbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:31:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762895AbYFWTbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:31:48 -0400
Date: Mon, 23 Jun 2008 12:30:04 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 0/5] 2.6.25-stable review
Message-ID: <20080623193004.GB15183@kroah.com>
References: <20080622190111.GA20141@suse.de> <200806231419.08436.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806231419.08436.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 02:19:05PM +0300, S.Çağlar Onur wrote:
> Hi Greg and -stable team;
> 
> 22 Haz 2008 Paz tarihinde, Greg KH şunları yazmıştı: 
> > Responses should be made by Tuesday, June 24, 18:00:00 UTC.  Anything
> > received after that time might be too late.
> 
> Please consider following commit for -stable also, it definetly fixes a boot failure caused by reported opps
> 
> commit 1f6ef2342972dc7fd623f360f84006e2304eb935

Thanks, I've added that one now as well.

greg k-h
