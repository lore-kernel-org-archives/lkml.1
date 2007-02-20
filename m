Return-Path: <linux-kernel-owner+w=401wt.eu-S1161065AbXBTXPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065AbXBTXPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161068AbXBTXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:15:04 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:52082 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161065AbXBTXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:15:03 -0500
Date: Wed, 21 Feb 2007 00:15:10 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070220231510.GC3690@mail.muni.cz>
References: <20070220214716.GA3690@mail.muni.cz> <45DB74FC.2070102@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45DB74FC.2070102@garzik.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Wed, 21 Feb 2007 00:14:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:23:56PM -0500, Jeff Garzik wrote:
> >introducing SATA ACPI does not work for me (I've filled the bug
> >report: http://bugzilla.kernel.org/show_bug.cgi?id=8046) beside those error
> >messages, IDE performance is decreased. libata.noacpi=1 option works ok but
> >the performance is still slightly degraded (about 10%).
> 
> Also, please add hardware info (full dmesg, full lspci) to the bug.

done.

-- 
Luká¹ Hejtmánek
