Return-Path: <linux-kernel-owner+w=401wt.eu-S965330AbXBLU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330AbXBLU0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965318AbXBLU0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:26:21 -0500
Received: from mail.cc.tut.fi ([130.230.1.120]:43064 "EHLO outbox.tut.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965330AbXBLU0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:26:20 -0500
X-Greylist: delayed 1979 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 15:26:20 EST
Date: Mon, 12 Feb 2007 21:53:18 +0200
From: Petri Kaukasoina <kaukasoina701m2os9b@sci.fi>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dave Jones <davej@redhat.com>, Valerie Henson <val_henson@linux.intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212195318.GB14369@elektroni.phys.tut.fi>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Dave Jones <davej@redhat.com>,
	Valerie Henson <val_henson@linux.intel.com>,
	Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
	lkml <linux-kernel@vger.kernel.org>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com> <20070212065503.GC20919@nifty> <20070212154010.GC7617@redhat.com> <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 06:49:39PM +0100, Jan Engelhardt wrote:
> >The one problem with noatime is that mutt's 'new mail arrived' breaks
> 
> Just why does not it use mtime then to check for New Mail Arrived, like 

I have always used:

  --enable-buffy-size        Use file size attribute instead of access time

Support was there at least in 1998, maybe before.
