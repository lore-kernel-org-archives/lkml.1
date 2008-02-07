Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYBGHZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYBGHZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbYBGHZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:25:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42858 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119AbYBGHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:25:17 -0500
Date: Wed, 6 Feb 2008 23:28:38 -0800
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Roel Kluin <12o3l@tiscali.nl>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [stable] [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test
	if (level & TP_EC_FAN_FULLSPEED)
Message-ID: <20080207072838.GA24592@kroah.com>
References: <47A78CBB.2090401@tiscali.nl> <ada8x20gykq.fsf@cisco.com> <47A79EC8.6060700@tiscali.nl> <20080205050504.GB30670@khazad-dum.debian.net> <47A81FAE.2090709@tiscali.nl> <20080206230702.GA12395@kroah.com> <47AA4748.3040702@tiscali.nl> <20080207011850.GC10122@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207011850.GC10122@khazad-dum.debian.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:18:50PM -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 07 Feb 2008, Roel Kluin wrote:
> > It's a oneliner and the patch is from linus' tree.
> 
> Roel, better to just let me and Len Brown handle it.  I will add your patch
> to my thinkpad-acpi queue and send it to Len soon, along with other simple
> patches that are pending.  Either I or Len will notify stable@k.o when it
> hits mainline.

Sounds good, I've dropped it from my queue, so please resend it when it
hits Linus's tree to stable@kernel.org if you want it there.

thanks,

greg k-h
