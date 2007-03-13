Return-Path: <linux-kernel-owner+w=401wt.eu-S1030671AbXCNG66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbXCNG66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030674AbXCNG66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:58:58 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:4284 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030671AbXCNG65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:58:57 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [5/6] 2.6.21-rc3: known regressions
Date: Tue, 13 Mar 2007 22:46:38 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Tomas Janousek <tomi@nomi.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Soeren Sonnenburg <kernel@nn7.de>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Lukas Hejtmanek <xhejtman@mail.muni.cz>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125016.GV18731@stusta.de>
In-Reply-To: <20070313125016.GV18731@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703132246.39253.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of March 2007, Adrian Bunk wrote:

> Subject    : ThinkPad Z60m: usb mouse stops working after suspend to ram
> References : http://lkml.org/lkml/2007/2/21/413
>              http://lkml.org/lkml/2007/2/28/172
> Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
> Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
>              commit 0a6139027f3986162233adc17285151e78b39cac
> Handled-By : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
> Status     : problem is being debugged

It's fixed in git tree. Commit ff24ba74b6d3befbfbafa142582211b5a6095d45

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
