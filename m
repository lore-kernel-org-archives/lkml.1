Return-Path: <linux-kernel-owner+w=401wt.eu-S1422784AbXCOAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422784AbXCOAoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXCOAoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:44:23 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:45208 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422784AbXCOAoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:44:22 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend to RAM)
Date: Thu, 15 Mar 2007 02:45:19 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
References: <200703140642.28390.ismail@pardus.org.tr> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de>
In-Reply-To: <45F88E8B.90403@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150245.20553.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 02:08:43 Stefan Richter wrote:
[...]
> Ismail, if you have the opportunity, the next thing you could test would
> be to unload eth1394 explicitly before ohci1394 on 2.6.21-rc3. This
> would _not_ oops according to my observation.

rmmod eth1394 and modprobe -r eth1394 both hangs here no oops nothing.

Regards.

-- 
Happiness in intelligent people is the rarest thing I know. (Ernest Hemingway)

Ismail Donmez ismail (at) pardus.org.tr
GPG Fingerprint: 7ACD 5836 7827 5598 D721 DF0D 1A9D 257A 5B88 F54C
Pardus Linux / KDE developer
