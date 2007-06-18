Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbXFRLDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbXFRLDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbXFRLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:02:55 -0400
Received: from smtp2.rz.uni-karlsruhe.de ([129.13.185.218]:42006 "EHLO
	smtp2.rz.uni-karlsruhe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760927AbXFRLCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:02:54 -0400
From: Malte Cornils <malte@cornils.net>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions
Date: Mon, 18 Jun 2007 13:02:42 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <467543E1.1060001@googlemail.com>
In-Reply-To: <467543E1.1060001@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181302.42951.malte@cornils.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Sonntag, 17. Juni 2007 16:23 schrieb Michal Piotrowski:
> Here is a list of some known regressions in 2.6.22-rc5.
> PCI
>
> Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
> References : http://lkml.org/lkml/2007/6/14/161
> Submitter  : Malte Cornils <malte@cornils.net>
> Status     : unknown

The original report was made on 2.6.22-rc3, I just checked and it still 
happens on 2.6.22-rc5.

Yours
-Malte Cornils
