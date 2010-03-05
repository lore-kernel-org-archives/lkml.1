Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0CEQyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:54:33 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:36120 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab0CEQyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:54:31 -0500
Date: Fri, 5 Mar 2010 17:54:30 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] serial: Add driver for the Altera UART
Message-ID: <20100305165430.GF20017@distanz.ch>
References: <cover.1267448534.git.klto@zhaw.ch> <15dc056891fb785001073bab4f9a0d0f3bf99af1.1267448534.git.klto@zhaw.ch> <afb4f2a75a6a35853774b10f34635a1d52d4cebd.1267448534.git.klto@zhaw.ch> <20100301181920.3952c3e7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301181920.3952c3e7@lxorguk.ukuu.org.uk>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-01 at 19:19:20 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> As the oddments that want adjusting can be done post merge and I'd rather
> see this in now than later as there are some serial_core changes cooking
> that will need to touch all drivers.

It doesn't seem that the drivers got merged yet, so I posted an updated
patchset adressing these oddments.

 Thanks a lot,
 Tobias
