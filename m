Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbXBJCKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbXBJCKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 21:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXBJCKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 21:10:03 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:48489 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXBJCKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 21:10:01 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Lee Revell <rlrevell@joe-job.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca>
	 <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 13:09:58 +1100
Message-Id: <1171073398.3863.9.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-02-09 at 20:59 -0500, Lee Revell wrote:
> On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > I would disagree that it's a peripheral issue, it's pretty core these
> > days, at least for any hardware that you can stuff in a laptop (though a
> > fair number of desktops get suspended and resumed these days too).
> 
> Servers are still the most important Linux market, and don't care
> about suspend/resume.  I would consider implementing suspend./resume
> for a driver that will only be used in server or HPC class hardware a
> waste of valuable development resources.

Not necessarily. Imagine suspending to disk in order to replace a faulty
card. That could be way faster and less disruptive than shutting down
normally and loosing caches and so on.

Irrespective of the above, servers tend not to have too much in the way
of hardware unique to them anyway, and even if you don't find it useful,
that's not to say others won't want it.

Regards,

Nigel

