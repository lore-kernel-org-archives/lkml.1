Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZJXJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZJXJTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZJXJS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:18:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49916 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZJXJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:18:59 -0400
Date: Sat, 24 Oct 2009 10:18:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4, ps2-to-usb adapter: fourth mouse button not working
Message-ID: <20091024091858.GA30614@srcf.ucam.org>
References: <1N1EA3-10pOoy0@fwd05.aul.t-online.de> <20091023073730.GB10914@srcf.ucam.org> <4AE2C572.1030209@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE2C572.1030209@t-online.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 11:14:26AM +0200, Harald Dunkel wrote:

> Is there a hardwired limit to 3 buttons somewhere in the code?

No, but your convertor may not understand wheel events. Does it work 
under Windows?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
