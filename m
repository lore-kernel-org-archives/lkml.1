Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZI3MtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZI3MtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZI3MtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:49:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZI3MtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:49:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver: vmxnet3
Date: Tue, 29 Sep 2009 23:23:20 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: bhavesh@vmware.com, chrisw@sous-sol.org, pv-drivers@vmware.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, greg@kroah.com,
       anthony@codemonkey.ws, jgarzik@pobox.com, akpm@linux-foundation.org,
       shemminger@linux-foundation.org
References: <20090929085333.GC3958@sequoia.sous-sol.org> <8B1F619C9F5F454E81D90D3C161698D7017DB76582@EXCH-MBX-3.vmware.com> <20090929.125530.31894576.davem@davemloft.net>
In-Reply-To: <20090929.125530.31894576.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909292323.20713.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iicpIVp5MKWB2TaUD/PFRGmZy/wEGcMW3oZj
 LsSCluSpJxHYLf8TmHY3V+jopC00MXlVgftOpwRYiek1z5acdh
 XIoeQDw3llGdQoJ5+rRCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 September 2009, David Miller wrote:
> > 
> > These header files are indeed shared with the host implementation,
> > as you've guessed. If it's not a big deal, we would like to keep
> > the names the same, just for our own sanity's sake?
> 
> No.  This isn't your source tree, it's everyone's.  So you should
> adhere to basic naming conventions and coding standards of the
> tree regardless of what you happen to use or need to use internally.

Well, there is nothing wrong with making the identifiers the same
everywhere, as long as they all follow the Linux coding style ;-).

I heard that a number of cross-OS device drivers do that nowadays.

	Arnd <><
