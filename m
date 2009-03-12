Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZCLJlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZCLJlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZCLJlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:41:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZCLJli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:41:38 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 3)
Date: Thu, 12 Mar 2009 10:41:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080724143151.GA32422@lenovo> <4889D767 <4889ED91.7050800@fujitsu-siemens.com>
In-Reply-To: <4889ED91.7050800@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903121041.34746.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Le vendredi 25 juillet 2008, Martin Wilck a écrit :
> Cyrill Gorcunov wrote:
> > Martin, it seems you forgot to attach the patch :) 
> 
> I am sorry, here it is. Thanks :)

Sorry for replying to such an old thread, but did this patch go
anywhere? I can't seem to find it in git. Was it somehow obsoleted
by a different fix for the same issue (SMI flood during APIC
calibration)? Or is the upstream kernel still affected?

Thanks,
-- 
Jean Delvare
Suse L3
