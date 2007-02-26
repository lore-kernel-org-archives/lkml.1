Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXBZAAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXBZAAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbXBZAAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:00:24 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44245 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932367AbXBZAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:00:24 -0500
Date: Mon, 26 Feb 2007 01:00:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
Message-ID: <20070226000023.GH29575@stusta.de>
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070221173445.GA16071@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070221173445.GA16071@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 09:34:45AM -0800, Greg KH wrote:
> On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.??a??lar Onur wrote:
> > 21 ??ub 2007 ??ar tarihinde, Greg KH ??unlar?? yazm????t??: 
> > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > received after that time might be too late.
> > 
> > We have still some CVEish patches in our package which maybe you want to 
> > consider adding into -stable.
> > 
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-4814
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5749
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5823
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6053
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6054
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006
> 
> Do you have a pointer to the patches for these fixes anywhere?
> 
> And are you sure they are all for 2.6.18?  The first one above is for
> the 2.4 kernel tree :)

Fixed in 2.6.19.2 and 2.6.18.8 (the latter contains a
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>  ;-) ).

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

