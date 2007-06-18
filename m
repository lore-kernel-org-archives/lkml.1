Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbXFRX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbXFRX0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXFRX0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:26:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764904AbXFRX0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:26:40 -0400
From: Malte Cornils <malte@cornils.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions
Date: Tue, 19 Jun 2007 01:26:22 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       reiserfs-devel@vger.kernel.org, "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>
References: <467543E1.1060001@googlemail.com> <200706181302.42951.malte@cornils.net> <20070618162915.GA7440@kroah.com>
In-Reply-To: <20070618162915.GA7440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190126.23091.malte@cornils.net>
X-Provags-ID: V01U2FsdGVkX1+qBdM5YSMa1me7z+alyJWSKuXJKEHDFB8k0hM
 a4xqi6CvxsNvVruXrsSCF72a91iAaDb9OT8RAzPVn1aY1+P1hp
 6Sqruxk1gOV5fShDV+ZQQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Montag, 18. Juni 2007 18:29 schrieb Greg KH:
> On Mon, Jun 18, 2007 at 01:02:42PM +0200, Malte Cornils wrote:
> > Hello,
> > > Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
> > > References : http://lkml.org/lkml/2007/6/14/161
> > > Submitter  : Malte Cornils <malte@cornils.net>
> > > Status     : unknown
> >
> > The original report was made on 2.6.22-rc3, I just checked and it still
> > happens on 2.6.22-rc5.
>
> Can you use 'git bisect' to track down the patch that causes this to
> fail?

I will do this, however, it will likely take me a day or two to find. I'll 
report back then.

-Malte Cornils
