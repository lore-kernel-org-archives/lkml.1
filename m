Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbXHWM3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbXHWM3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763471AbXHWM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:28:31 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57242 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbXHWM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:28:28 -0400
Date: Wed, 22 Aug 2007 23:03:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       source@mvista.com, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz, netdev@vger.kernel.org,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       gtolstolytkin@ru.mvista.com, vitalywool@gmail.com, dsaxena@plexity.net,
       linux-mips@linux-mips.org, mchehab@infradead.org,
       video4linux-list@redhat.com, jbenc@suse.cz, flamingice@sourmilk.net,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] define global BIT macro
Message-ID: <20070822220321.GA4473@linux-mips.org>
References: <737828602404912540@wsc.cz> <428714662539710215@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <428714662539710215@wsc.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 11:44:12AM +0200, Jiri Slaby wrote:

> define global BIT macro
> 
> move all local BIT defines to the new globally define macro.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

for the MACE ethernet and MIPS bits.

  Ralf
