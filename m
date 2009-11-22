Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZKVV1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZKVV1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 16:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZKVV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 16:27:47 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:51512 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbZKVV1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 16:27:46 -0500
References: <200911200823.58897@fortytwo.ch>
Message-ID: <cone.1258925270.277361.2967.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Adrian von Bidder <avbidder@fortytwo.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: acerhdf: stilll fighting between kernel and BIOS?
Date: Sun, 22 Nov 2009 22:27:50 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Adrian,

issues with AOA 150 netbooks should be solved with current 2.6.32-git tree. 
You can also try to use latest acerhdf of http://piie.net

kind regards,
--peter

Adrian von Bidder writes:

> Heyho!
> 
> With 2.6.31 (as packaged by Debian), kernel and BIOS are still fighting over 
> who controls the fan on my Acer AOA-150.
> 
> If the system is idle, I see repeated 
> 
> Nov 20 08:07:12 laeggerli kernel: [100246.224141] acerhdf: temp 51      
> Nov 20 08:07:12 laeggerli kernel: [100246.272136] acerhdf: fan OFF      
> Nov 20 08:07:22 laeggerli kernel: [100256.328145] acerhdf: temp 51      
> Nov 20 08:07:22 laeggerli kernel: [100256.376072] acerhdf: fan OFF      
> 
> (and the fan is turned on and off accordingly, using a rather noisy speed 
> for ca. .5s every time.)
> 
> As soon as the system gets a bit warmer, fan is running on low speed and the 
> system is much quieter.
> 
> ISTR reading that this should have been fixed in 2.6.31, or was that wrong?  
> Did anything change in current kernels or the separate releases of the 
> acerhdf driver?  I might be able to run newer driver releases, or at least I 
> can provide more info if desired (and if you're patient to deal with quite 
> slow round trip times from my side.  It's not an urgent problem either.)
> 
> 
> cheers
> -- vbi
> 
> -- 
> featured product: ClamAV Antivirus - http://www.clamav.net/
