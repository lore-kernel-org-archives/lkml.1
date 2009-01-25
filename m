Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZAYSEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZAYSEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 13:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZAYSEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 13:04:32 -0500
Received: from rtr.ca ([76.10.145.34]:55615 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZAYSEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 13:04:32 -0500
Message-ID: <497CA9AC.7030208@rtr.ca>
Date: Sun, 25 Jan 2009 13:04:28 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
..
> Mount by label also means you can flip back and forth between the
> different drivers and kernel revisions.
..

That only works with an initrd or initramfs,
not with kernel-only boots.  Real P.I.T.A. that is.
