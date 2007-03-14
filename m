Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbXCNWud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbXCNWud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXCNWud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:50:33 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:53528 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318AbXCNWuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:50:32 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend to RAM)
Date: Thu, 15 Mar 2007 00:51:29 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
References: <200703140642.28390.ismail@pardus.org.tr> <200703141858.39531.ismail@pardus.org.tr> <45F83E14.3060003@s5r6.in-berlin.de>
In-Reply-To: <45F83E14.3060003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703150051.29945.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 20:25:24 Stefan Richter wrote:
> Ismail Dönmez wrote:
> > On Wednesday 14 March 2007 13:14:42 Stefan Richter wrote:
> >> Do you have a script or config which marks the
> >> ohci1394 module to be unloaded before suspend?
> >
> > I used kpowersave to suspend, I failed to find anything related to
> > ohci1394 in its config but rmmod ohci1394 gives exact oops so it must be
> > rmmoding it.
>
> [...]
>
> > Are you able to rmmod it?
>
> Yes, but on 2.6.20 and earlier kernels, most of the time with
> development versions of the 1394 drivers. I still haven't tried
> 2.6.21-rc, will hopefully get to it tonight.

Ok then that explains a bit, without suspend if I rmmod ohci1394 module I got 
the exact oops.

Regards.

-- 
Happiness in intelligent people is the rarest thing I know. (Ernest Hemingway)

Ismail Donmez ismail (at) pardus.org.tr
GPG Fingerprint: 7ACD 5836 7827 5598 D721 DF0D 1A9D 257A 5B88 F54C
Pardus Linux / KDE developer
