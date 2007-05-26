Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbXEZVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbXEZVSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbXEZVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:18:16 -0400
Received: from smtp.knology.net ([24.214.63.101]:58848 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXEZVSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:18:14 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 17:18:14 EDT
Subject: Re: [PATCH, RFT, v4] sata_mv: convert to new EH
From: Dave Dillow <dave@thedillows.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: dean gaudet <dean@arctic.org>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46589F15.8080003@garzik.org>
References: <20070225233454.GA31282@havoc.gtf.org>
	 <1173158201.3416.8.camel@obelisk.thedillows.org>
	 <45ED039E.20608@garzik.org>
	 <1173164261.3416.15.camel@obelisk.thedillows.org>
	 <4656EB26.40504@garzik.org> <4657A678.8090308@garzik.org>
	 <Pine.LNX.4.64.0705252335590.8327@twinlark.arctic.org>
	 <46589F15.8080003@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 26 May 2007 17:11:32 -0400
Message-Id: <1180213892.19231.6.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 16:56 -0400, Jeff Garzik wrote:
> Dave, any chance you could try 2.6.22-rc3 + my v4 patch, on a different 
> hard drive?  Preferably a non-Maxtor, or at least not another Maxtor 
> 6L200S0.  If that's a big deal, don't worry about it.  I just want to 
> rule out buggy firmware and/or bad hard drive in your case.

It is likely I can come up with at least one, and maybe two if I
cannibalize my main machine... do you want results under all three
kernels or just the v4 patch?

Dave
