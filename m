Return-Path: <linux-kernel-owner+w=401wt.eu-S935046AbZKYVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbZKYVoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZKYVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:44:08 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:65096 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbZKYVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:44:07 -0500
Date: Wed, 25 Nov 2009 16:43:59 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH 2/2] acerhdf: Added new BIOS versions
In-reply-to: <20091111152935.5fad5071.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0911251640580.3950@localhost.localdomain>
References: <20091109185105.6028c057.peter@piie.net>
 <20091109185335.26836808.peter@piie.net>
 <20091111152935.5fad5071.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Andrew Morton wrote:

> Len, patch 1/2 looks like 2.6.32 material to me?
> 
> Ordinarily I'd consider an add-device-support patch like 2/2 to be
> 2.6.32 material also, but this one looks a bit large and scary for that
> treatment.

Agreed on both points.
I sent the 1st patch up yesterday --
though I've not seen any pulls from Linus today...

The fact that the 1st patch was necessary suggests that this driver
is thinkly tested, and so patch #2 should wait for the merge window
like most patches do.

thanks,
-Len Brown, Intel Open Source Technology Center


