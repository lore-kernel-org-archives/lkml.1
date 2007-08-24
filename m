Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbXHXCED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbXHXCED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXHXCDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:03:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44505 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbXHXCDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:03:51 -0400
Date: Thu, 23 Aug 2007 20:03:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>, linux@connectcom.net
Subject: Re: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
Message-ID: <20070824020349.GS9163@parisc-linux.org>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 02:16:12AM +0200, Jesper Juhl wrote:
> There's no reason to cast void pointers returned by the generic
> memory allocation functions.

I think I fixed all these already; please check scsi-misc.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
