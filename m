Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYHVBJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYHVBJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYHVBJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:09:42 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47823 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYHVBJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:09:41 -0400
X-Sasl-enc: dz1VxYEz/pQsZykS7iBMZs+szt91MPDxkgpKu0kWVOPL 1219367380
Date: Thu, 21 Aug 2008 22:09:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080822010933.GD6105@khazad-dum.debian.net>
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <200808211523.35556.jbarnes@virtuousgeek.org> <20080822010451.GC6105@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822010451.GC6105@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 21 Aug 2008, Jesse Barnes wrote:
> > Wow, thanks Greg, that was fast.  I applied this to my for-linus branch; I'll 
> > ask Linus to pull it for 2.6.27.
> 
> Does 2.6.26 need it as well?

Never mind, I just read Greg's reply.  It arrived a few seconds after I sent
this.  Sorry about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
