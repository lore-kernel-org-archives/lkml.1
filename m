Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZJCPA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZJCPA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 11:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZJCPA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 11:00:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52600 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546AbZJCPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 11:00:55 -0400
X-Sasl-enc: M4Wv/bHF2HtU89PWViZbkxn84t9IvLC4jySITh/0StuZ 1254582018
Date: Sat, 3 Oct 2009 12:00:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Wang, Shane" <shane.wang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091003150013.GD31552@khazad-dum.debian.net>
References: <200909282307.56190.rjw@sisk.pl>
 <4AC1267D.6020405@zytor.com>
 <20090928211745.GA2119@elf.ucw.cz>
 <4AC1AA61.8070408@intel.com>
 <20090929171318.GC14405@elf.ucw.cz>
 <20090929191951.18315e94@infradead.org>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
 <20090930065448.GB11652@elf.ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
 <4AC635D5.8080809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC635D5.8080809@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009, H. Peter Anvin wrote:
> On 10/02/2009 10:02 AM, Wang, Shane wrote:
> >> So I modify the RAM content so that BIOS does not think measured
> >> environment existed before suspend?
> > 
> > Hi Pavel, what do you mean on this question? 
> > When do you modify the RAM? before S3 sleep?
> > 
> 
> He was talking earlier about a liquid nitrogen freeze attack.

You wish one would need liquid nitrogen for it... frozen CO2 (dry ice) is
more than cold enough for such an attack, and _MUCH_ easier to both acquire
and handle than liquid nitrogen.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
