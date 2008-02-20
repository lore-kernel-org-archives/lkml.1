Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYBTRTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYBTRTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYBTRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:19:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:51915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbYBTRTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TiElnEb5FUMayztPzO5V+kW0hAOLBpmlHN9iILhpN+fMnuMpTSF2eTxkN2oXo0I7a54SSGBLBbDOrTokZ/qK2Ke8D24xuVIRC2najMiHK2hAxRMiLvX0IRPQR+Rvdxu1coflOuw5f8uj3DaQOQXMB+rfj4seFrHLxoYFABg6S5c=
Message-ID: <b6a2187b0802200919x4d60eecfp2b4740b20fc095ec@mail.gmail.com>
Date: Thu, 21 Feb 2008 01:19:34 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21, 2008 1:17 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> On Feb 20, 2008 2:19 PM, Jeff Chua
> > I'll try the "idle=poll" to see if that works and will try some printk

Tried "idle=poll" but it has not effect.

Thanks,
Jeff.
