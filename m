Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZBCEd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZBCEd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZBCEds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:33:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:57692 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZBCEdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R3HcygogxDbVQp4VkuLIaH1EhReeZ58yIoLxReUa/GRZWB2LMntX2DDRWdfbPC1iCQ
         b/E5kvOvuVY/clqVifRpsjNKO7UFsMhHDsiqduruFQ08VUc/uNBGC17ddwMTUfcxtCfU
         jK7rwlrdOf9mGBCR75W0J5OTok7ld3nTm/Oc0=
MIME-Version: 1.0
In-Reply-To: <200902022257.36541.rjw@sisk.pl>
References: <a44ae5cd0902021331u715b7068s2e43440e3a180966@mail.gmail.com>
	 <200902022257.36541.rjw@sisk.pl>
Date: Mon, 2 Feb 2009 23:33:45 -0500
Message-ID: <a44ae5cd0902022033r7a8ea5dbi24324e84f06931b8@mail.gmail.com>
Subject: Re: 2.6.29-rc3-git3 -- WARNING: at drivers/pci/pci-driver.c:368 
	pci_legacy_suspend+0x7e/0xbb()
From: Miles Lane <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 4:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Please have a look at this thread:
> http://lkml.org/lkml/2009/2/1/49
>
> Thanks,
> Rafael
>

Thanks.  The patch fixed this particular problem.
