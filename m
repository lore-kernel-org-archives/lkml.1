Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXIYJVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXIYJVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXIYJVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:21:36 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43040 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXIYJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:21:35 -0400
Date: Tue, 25 Sep 2007 11:22:39 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata broken on Pegasos PPC platform (was: Re: IDE broken on Pegasos PPC platform)
Message-ID: <20070925092239.GA7127@aepfle.de>
References: <46F80BB1.7050902@redhat.com> <200709242258.28497.bzolnier@gmail.com> <20070924221041.309b08e9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070924221041.309b08e9@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, Alan Cox wrote:

> hopefully that means the hack in the old VIA driver can also be killed
> off.

Not that I know. But I did not browse the IDE core long enough to figure
out how to assign both irqs in a generic way.
