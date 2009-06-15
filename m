Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZFOLls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZFOLls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFOLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:41:40 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:56609 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZFOLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:41:39 -0400
In-Reply-To: <20090615112628.GA26150@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: [GIT PULL] new files for score architecture
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF28F09400.68D4B737-ON482575D6.003FA1F3-482575D6.00403088@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 15 Jun 2009 19:36:33 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/15 ?? 07:36:33,
	Serialize complete at 2009/06/15 ?? 07:36:33
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5FBgO54011576

Hi Christoph Hellwig,

Christoph Hellwig <hch@infradead.org> Ğ´ÓÚ 2009-06-15 19:26:28:

> On Mon, Jun 15, 2009 at 11:21:01AM +0800, liqin.chen@sunplusct.com 
wrote:
> > Hi Linus,
> > 
> > This pack contains initial pack for S+core CPU.
> > The patches are reviewed by Arnd and many people.
> > Because I have not get the git repository now, 
> > So Arnd kindly commit score patch into 
> > git/arnd/asm-generic.git.
> 
> As mentioned before the ptrace implementation is badly wrong as it's
> been copy and pasted from a years old stage of some other architecture
> and just munged enough to compile.
> 

Thanks your comment, I had removed unused code from ptrace.

Best Regards
Liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
