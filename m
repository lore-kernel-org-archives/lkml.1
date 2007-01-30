Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbXA3BCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbXA3BCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964860AbXA3BCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:02:44 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:49366 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbXA3BCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:02:43 -0500
Date: Tue, 30 Jan 2007 10:00:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-mips@linux-mips.org
Subject: Re: Advice on APM-EMU reunion
Message-ID: <20070130010055.GA15907@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk, linux-mips@linux-mips.org
References: <20070129230755.GA8705@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129230755.GA8705@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 12:07:56AM +0100, Rodolfo Giometti wrote:
> some months ago I sent to the MIPS and ARM mail lists a patch to unify
> the several APM emulation codes adding a new dedicated directory so it
> can be used to put there the per board specific code avoiding code
> duplications (see files ./arch/arm/kernel/apm.c,
> ./arch/mips/kernel/apm.c and ./arch/sh/kernel/apm.c that are almost
> the same).
> 
> The patch is here
> "http://www.linux-mips.org/archives/linux-mips/2006-07/msg00144.html"
> and it has been lost in the deep space...
> 
Not quite, the rationale for it being dropped was here:

http://article.gmane.org/gmane.linux.kernel/485831

However, it has since been reposted:

http://article.gmane.org/gmane.linux.kernel/485833
http://article.gmane.org/gmane.linux.kernel/485834
http://article.gmane.org/gmane.linux.kernel/485835
http://article.gmane.org/gmane.linux.kernel/485837

and merged back in to -mm. This is all post 2.6.20 stuff, though..
