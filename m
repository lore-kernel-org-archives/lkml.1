Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZFOLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZFOLqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZFOLqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:46:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZFOLqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:46:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [GIT PULL] new files for score architecture
Date: Mon, 15 Jun 2009 13:46:01 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <OF28F09400.68D4B737-ON482575D6.003FA1F3-482575D6.00403088@sunplusct.com>
In-Reply-To: <OF28F09400.68D4B737-ON482575D6.003FA1F3-482575D6.00403088@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <200906151346.02022.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2zg4OPK1ONmo6F0UdyHtvNCnYt1SDwnhc93h
 DQHGPNmX8UFR48Lh8kpcgEpBwT5chKTXl1bnvPnmOfYJjekdw/
 pwQA1Np1QNwEyXyKn0YBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, liqin.chen@sunplusct.com wrote:
> Hi Christoph Hellwig,
> 
> Christoph Hellwig <hch@infradead.org> Ð´ÓÚ 2009-06-15 19:26:28:
> 
> > On Mon, Jun 15, 2009 at 11:21:01AM +0800, liqin.chen@sunplusct.com 
> wrote:
> > > Hi Linus,
> > > 
> > > This pack contains initial pack for S+core CPU.
> > > The patches are reviewed by Arnd and many people.
> > > Because I have not get the git repository now, 
> > > So Arnd kindly commit score patch into 
> > > git/arnd/asm-generic.git.
> > 
> > As mentioned before the ptrace implementation is badly wrong as it's
> > been copy and pasted from a years old stage of some other architecture
> > and just munged enough to compile.
> > 
> 
> Thanks your comment, I had removed unused code from ptrace.

Ok. Please just send a diff relative to the git tree in my directory,
I'll integrate that.

	Arnd <><
