Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYD2UXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYD2UXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYD2UXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:23:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbYD2UXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:23:06 -0400
Date: Tue, 29 Apr 2008 21:17:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Denis V. Lunev" <den@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429201704.GA31311@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429182709.GB2898@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> came through -mm that contains a patch implementing the overdue removal 
> of the PCMCIA control ioctl that did not yet make it into Linus' tree:

Okay, this means at least one of my platforms is now dead as far as
building new kernels for it, and nothing I can do about that.  Ho hum.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
