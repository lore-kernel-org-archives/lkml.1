Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXEPCjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXEPCjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXEPCjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:39:06 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43925 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbXEPCjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:39:05 -0400
Date: Wed, 16 May 2007 03:38:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-input@atrey.karlin.mff.cuni.cz,
       nicolas@boichat.ch, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20070516023846.GA29187@srcf.ucam.org>
References: <1178995886.4168.10.camel@localhost> <20070513172052.GA26712@srcf.ucam.org> <20070513114626.d943999a.zaitcev@redhat.com> <20070513195724.GA28493@srcf.ucam.org> <20070513185807.18222a0d.zaitcev@redhat.com> <1179261295.18316.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179261295.18316.9.camel@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Make appletouch shut up when it has nothing to say
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:34:55PM +0000, Soeren Sonnenburg wrote:

> I was using this patch for some days now and I realized that - from time
> to time - the touchpad runs amok, i.e. I more or less unable to control
> the mouse when that happens.

Hmm. Just seen this. I'll see if I can work around that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
