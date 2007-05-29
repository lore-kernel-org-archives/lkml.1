Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbXE2M4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbXE2M4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXE2M4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:56:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41624 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXE2M4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=uH5NnPTSaFxVCQyLkffYxdrY3tWZAtOMM3d8rzIYVHwLD3B7LlJYIVEOqfZNC6H8gl9p/UU4fKotr2bzjCBmHecOmlUs25Dz0in0S9vxWoWGvZZYEuN1nOQJUG1gVvWn0Nmu3lh01wG1I0Njb4tpsvlQes6bcmdSWcPxy3aa1pE=
Message-ID: <465C22F4.8080505@googlemail.com>
Date: Tue, 29 May 2007 14:56:20 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Ruben <nahoo82@terra.es>, Stephen Hemminger <shemminger@osdl.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       tom.l.nguyen@intel.com, linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
References: <465C188F.9000900@googlemail.com>
In-Reply-To: <465C188F.9000900@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : Network card not usable - sky2
References : http://bugzilla.kernel.org/show_bug.cgi?id=8539
Submitter  : Ruben <nahoo82@terra.es>
Status     : Unknown



PCI

Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
References : http://lkml.org/lkml/2007/5/24/172
Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
Status     : Unknown



PCMCIA

Subject    : libata and legacy ide pcmcia failure
References : http://lkml.org/lkml/2007/5/17/305
Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
Status     : Unknown



SATA/PATA

Subject    : 22-rc3 broke the CDROM in Dell notebook
References : http://lkml.org/lkml/2007/5/27/63
Submitter  : Gregor Jasny <gjasny@googlemail.com>
Handled-By : Tejun Heo <htejun@gmail.com>
             Jeff Garzik <jeff@garzik.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc
Status     : problem is being debugged



Sparc64

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

