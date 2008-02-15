Return-Path: <linux-kernel-owner+w=401wt.eu-S1763752AbYBOMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763752AbYBOMDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYBOMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:03:05 -0500
Received: from styx.suse.cz ([82.119.242.94]:54500 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbYBOMDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:03:04 -0500
Subject: Re: [PATCH] arm/pxa/spitz.h rewritten and commented
From: Stanislav Brabec <utx@penguin.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <1203011402.7179.2.camel@hammer.suse.cz>
References: <1203011402.7179.2.camel@hammer.suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Date: Fri, 15 Feb 2008 13:02:58 +0100
Message-Id: <1203076978.7179.52.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Brabec wrote:
> Here is a rewrite of spitz.h, which includes comments documenting
> function of particular GPIO pins.
> 
> spitz_h_rewrite.patch provides:
> - no changes in compiled code
> - partial spitz.h rewrite:
>   * organized by function
>   * describes complete GPIO pinout
>   * comments added
>   * removed defines cloning pxa-regs.h
> - prefer generic pxa-regs.h GPIO if available
> - use GPIO names instead of numbers

Please don't apply. Future GPIO order in spitz.h needs further
discussion with Richard Purdie.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

