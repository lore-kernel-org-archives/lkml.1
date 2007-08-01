Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbXHAMLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbXHAMLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbXHAMLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:11:21 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50701 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbXHAMLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:11:20 -0400
Date: Wed, 1 Aug 2007 14:11:10 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Chr <chunkeey@web.de>
cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Cleaning up the USBHID's blacklist.
In-Reply-To: <200707312324.06116.chunkeey@web.de>
Message-ID: <Pine.LNX.4.64.0708011409460.26230@twin.jikos.cz>
References: <200707240228.39421.chunkeey@web.de> <200707301611.08758.chunkeey@web.de>
 <Pine.LNX.4.64.0707311038400.5747@twin.jikos.cz> <200707312324.06116.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Chr wrote:

> But I have one (final?) question. Since I am sometimes stuck to 80x25 
> console...
>  can we alphabetically sort the blacklist by the Vendor (the first 
> field), instead of the quirk field(last field)? Or is there a 
> technical/theoretical reason behind it?

I find the blacklist sorted by quirk type more convenient - we typically 
want to know "who has this particular quirk", but we generally don't care 
"what quirks does this particular vendor have".

-- 
Jiri Kosina
