Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbXD0MMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbXD0MMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXD0MMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:12:40 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42865 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbXD0MMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:12:14 -0400
X-Originating-Ip: 74.109.98.66
Date: Fri, 27 Apr 2007 08:11:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Marat Buharov <marat.buharov@gmail.com>
cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Parav K Pandit <Parav_Pandit@mindtree.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: assembly code in the loadable kernel module
In-Reply-To: <698310e10704270457p7fce899ao16dee58b5e16869c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704270807460.18333@localhost.localdomain>
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
  <Pine.LNX.4.61.0704270726080.3369@chaos.analogic.com>
 <698310e10704270457p7fce899ao16dee58b5e16869c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Marat Buharov wrote:

> On 4/27/07, Parav K Pandit <Parav_Pandit@mindtree.com> wrote:
> > DISCLAIMER:
> > This message (including attachment if any) is confidential and may be
> > privileged. Before opening attachments please check them for viruses and
> > defects. MindTree Consulting Limited (MindTree) will not be responsible for
> > any viruses or defects or any forwarded attachments emanating either from
> > within MindTree or outside. If you have received this message by mistake
> > please notify the sender by return  e-mail and delete this message from your
> > system. Any unauthorized use or dissemination of this message in whole or in
> > part is strictly prohibited.  Please note that e-mails are susceptible to
> > change and MindTree shall not be liable for any improper, untimely or
> > incomplete transmission.
>
> On 4/27/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > ****************************************************************
> > The information transmitted in this message is confidential and may be
> > privileged.  Any review, retransmission, dissemination, or other use of this
> > information by persons or entities other than the intended recipient is
> > prohibited.  If you are not the intended recipient, please notify Analogic
> > Corporation immediately - by replying to this message or by sending an email
> > to DeliveryErrors@analogic.com - and destroy all copies of this information,
> > including any attachments, without reading or disclosing them.
>
> Damn, people. Please, remove that sort of disclaimers (about
> confidential information) while posting to public mailing lists.

good luck.  this issue comes up on a regular basis on mailing lists
all over the place and the response is always the same -- some
companies, based on the advice of their legal departments, absolutely
*require* those rambling, worthless disclaimers, and the senders have
no ability whatsoever to turn them off.

there is only one solution to that sort of thing -- blacklist the
entire sending domain until they get a clue.  yes, it's draconian, but
there's really no other way to educate them.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
