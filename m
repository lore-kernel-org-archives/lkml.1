Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYGZDuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYGZDuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGZDuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:50:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:48187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYGZDuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:50:01 -0400
Date: Fri, 25 Jul 2008 20:44:13 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 0/9] 2.6.25-stable review
Message-ID: <20080726034413.GA17602@suse.de>
References: <20080725230644.GA1612@suse.de> <j74l84livfi260fi8glgpd09m9q7igqnu0@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j74l84livfi260fi8glgpd09m9q7igqnu0@4ax.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 12:54:14PM +1000, Grant Coady wrote:
> On Fri, 25 Jul 2008 16:06:44 -0700, Greg KH <gregkh@suse.de> wrote:
> 
> >This is the start of the stable review cycle for the 2.6.25.13 release.
> >There are 9 patches in this series, all will be posted as a response to
> >this one.  If anyone has any issues with these being applied, please let
> >us know.  If anyone is a maintainer of the proper subsystem, and wants
> >to add a Signed-off-by: line to the patch, please respond with it.
> >
> >These patches are sent out with a number of different people on the Cc:
> >line.  If you wish to be a reviewer, please email stable@kernel.org to
> >add your name to the list.  If you want to be off the reviewer list,
> >also email us.
> >
> >Responses should be made by Monday, July 28, 12:00:00 UTC.  Anything
> >received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.13-rc1.gz
> >and the diffstat can be found below.
> 
> Being very brave or very silly, I put this on my firewall box due to the 
> PPPoE changes, I run ADSL modem in bridge mode, not noticed any problems :)

Great, thanks for testing, I appreciate it.

greg k-h
