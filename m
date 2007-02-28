Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXB1Vuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXB1Vuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXB1VuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:50:20 -0500
Received: from sf01.pol.net ([63.240.86.10]:37641 "EHLO sf01.pol.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbXB1VuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:50:08 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 16:50:08 EST
Message-ID: <18746.10.250.10.1.1172699075.squirrel@webmail.medscape.com>
Date: Thu, 1 Mar 2007 05:44:35 +0800 (PHT)
Subject: Re: fix implicit declaration in nv_backlight.
From: "Antonino A. Daplas" <adaplas@pol.net>
To: <linux-kernel@hansmi.ch>
In-Reply-To: <20070228211324.GA26983@hansmi.ch>
References: <20070228173625.GA3359@redhat.com>
        <20070228211324.GA26983@hansmi.ch>
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
Cc: <davej@redhat.com>, <linux-kernel@vger.kernel.org>, <adaplas@pol.net>
Reply-To: adaplas@pol.net
X-Mailer: SquirrelMail (version 1.2.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> On Wed, Feb 28, 2007 at 12:36:25PM -0500, Dave Jones wrote:
>> +#ifdef __powerpc__
>
> Is __powerpc__ defined when cross compiling? I'd rather use
> CONFIG_PMAC_BACKLIGHT instead of it.

Agree with this too.

Tony



