Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZKLT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZKLT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZKLT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:26:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50733 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZKLT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:26:58 -0500
Date: Thu, 12 Nov 2009 19:26:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bdale Garbee <bdale@gag.com>, linux-kernel@vger.kernel.org
Subject: Re: problem with codec discovery on HP 2530p
Message-ID: <20091112192653.GA12310@srcf.ucam.org>
References: <20091110145338.A55E719D7AD@rover.gag.com> <s5hy6mel48j.wl%tiwai@suse.de> <1257886598.4701.3.camel@rover> <s5hy6md600u.wl%tiwai@suse.de> <1257976083.5237.1.camel@rover> <s5hljicdytp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hljicdytp.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 07:47:14AM +0100, Takashi Iwai wrote:

> BTW, with your laptop, which option is more suitable, model=laptop or
> model=mobile?
> I'm going to add a quirk entry for your device, but I need to know
> which model is most appropriate.

The 2530p seems to work fine with current upstream - it's caught by one 
of the generic HP laptop quirks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
