Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXJLVIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXJLVIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXJLVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:08:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56496 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbXJLVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:08:25 -0400
Message-ID: <470FE245.5040702@garzik.org>
Date: Fri, 12 Oct 2007 17:08:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bernd Schubert <bs@q-leap.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] faster workaround
References: <200710081709.18253.bs@q-leap.de> <200710111639.38240.bs@q-leap.de> <470E3B8D.4080002@garzik.org> <200710111718.43159.bs@q-leap.de>
In-Reply-To: <200710111718.43159.bs@q-leap.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:
> a) 2.6.23 + sil-patch I posted, this is on a customer system (though my former 
> group), I wouldn't like to use -mm there.
> 
> b) .config is attached
> 
> c) attached
> 
> d) attached (don't get irritaded by those machine check events, thats "GART 
> TLB errorr", harmless warnings, just not disabled in the bios).

Any chance you could provide dmesg on 2.6.23 without the sil patch?

	Jeff



