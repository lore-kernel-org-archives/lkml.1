Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYDGKbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYDGKbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbYDGKb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:31:28 -0400
Received: from mail.suse.de ([195.135.220.2]:49341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbYDGKb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:31:27 -0400
Message-ID: <47F9F7FD.908@suse.de>
Date: Mon, 07 Apr 2008 12:31:25 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
References: <200803230440.40685.vda.linux@googlemail.com> <200803230441.22926.vda.linux@googlemail.com>
In-Reply-To: <200803230441.22926.vda.linux@googlemail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

Denys Vlasenko wrote:
> Deinlines and moves big functions from .h to .c files.
> Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
Patch looks good to me.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
