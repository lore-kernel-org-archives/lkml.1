Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0CJOYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:24:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39774 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab0CJOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:24:40 -0500
Date: Wed, 10 Mar 2010 14:24:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Evan McClain <evan.mcclain@gatech.edu>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, schwalbe@inf.tu-dresden.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook
	variants
Message-ID: <20100310142424.GA21625@srcf.ucam.org>
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked in principle, but at this point it probably needs to be renamed 
and have the Kconfig entry updated if it's going to be used for other 
hardware. Does it actually work on non-nvidia Macs?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
