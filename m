Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZEGRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZEGRiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbZEGRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:38:31 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55969 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbZEGRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:38:29 -0400
X-Originating-Ip: 216.16.235.2
Date: Thu, 7 May 2009 13:23:04 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Greg KH <gregkh@suse.de>, chrisw@sous-sol.org, smfrench@gmail.com,
       jlayton@redhat.com
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
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/58] 2.6.29.3-stable review
Message-ID: <20090507172301.GA28595@foursquare.net>
References: <20090506215017.GA21981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506215017.GA21981@kroah.com>
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-Net-Direct-Inc-MailScanner-From: cdfrey@foursquare.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 02:50:17PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.29.3 release.
> There are 58 patches in this series, all will be posted as a response to
> this one.

Maybe I'm missing something, but I don't see any of
the fs/cifs/connect.c security fixes from commits such as
f083def68f84b04fe3f97312498911afce79609e.  I was hoping this would make
it into 2.6.29.3.

For reference, this was discussed on full-disclosure:
	http://marc.info/?l=full-disclosure&m=123936563230145&w=2
	(near the end of Andreas's post)

Jeff and Steve mentioned last week that they were working on other related
cleanups as well, that they hoped to push to stable.

Thanks,
- Chris

