Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZJZWbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZJZWbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZJZWbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:31:01 -0400
Received: from 17.mail-out.ovh.net ([91.121.30.212]:40494 "HELO
	17.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754064AbZJZWbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:31:00 -0400
Date: Mon, 26 Oct 2009 23:11:29 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Re: Framebuffer support for HTC Dream
Message-ID: <20091026221129.GB23415@game.jcrosoft.org>
References: <20090629111029.GA15514@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629111029.GA15514@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2661345906206223187
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 2535808066690591511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:10 Mon 29 Jun     , Pavel Machek wrote:
> I cleaned up dead code, a lot of debugging infastructure and horrific
> logo code. I had to remove earlysuspend support, because neccessary
> headers are not in mainline. The driver still works :-).
> 
> I'd like to see it applied, working framebuffer is quite important for
> debugging / getting other drivers into working state.
> 
the include/linux/msm_mdp.h is missing

could you send a patch to add it?

Best Regards,
J.
