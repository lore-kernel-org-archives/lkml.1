Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXFUQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXFUQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbXFUQgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:36:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:42263 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbXFUQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=VrFbQCJyKgKbA7hRtNHqE3QOxRYeMqopg7hN6ZAcOdkDPdKWupHUbDnDAi7mkSYYZhjh1VZr77q2pWZCZIod1gShrYGvcEMMjuLj6UbEYuClFh7k9XuDhnEs5RqQl+sdlVpKG49JHNabI4MK7Z5qBLDpAv6R74qI0sr+Rxho2Is=
Message-ID: <467AA8CA.2020206@googlemail.com>
Date: Thu, 21 Jun 2007 18:35:22 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       =?ISO-8859-2?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Jean Delvare <khali@linux-fr.org>, Rudolf Marek <r.marek@assembler.cz>
Subject: [1/2] 2.6.22-rc5: known regressions with patches v2
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

(BTW. There is a new category called "Will be fixed in 2.6.23")



Unclassified

Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Handled-By : Siddha, Suresh B <suresh.b.siddha@intel.com>
Patch      : http://lkml.org/lkml/2007/6/19/422
Status     : patch available

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Patch      : http://lkml.org/lkml/2007/6/16/81
Status     : patch was suggested



FBDEV

Subject    : mach64 breakage in 2.6.22
References : http://lkml.org/lkml/2007/6/14/73
Submitter  : Olaf Hering <olaf@aepfle.de>
Handled-By : Ville Syrjälä <syrjala@sci.fi>
Patch      : http://lkml.org/lkml/2007/6/14/273
Status     : patch was suggested



HWMON

Subject    : latest coretemp changes break s2ram
References : http://lkml.org/lkml/2007/6/16/173
Submitter  : Soeren Sonnenburg <kernel@nn7.de>
Caused-By  : Rudolf Marek <r.marek@assembler.cz>
             commit 67f363b1f6a31cf5027a97372f64bcced4f05ba6
Handled-By : Jean Delvare <khali@linux-fr.org>
Patch      : http://lkml.org/lkml/2007/6/16/177
Status     : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
