Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZGTQhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZGTQhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZGTQhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:37:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48235 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbZGTQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:37:00 -0400
Date: Mon, 20 Jul 2009 17:37:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Hellstr?m <thomas@shipmail.org>,
       Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
 Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720173721.18ef82d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090720155745.GB12536@infradead.org>
References: <4A647358.1040009@shipmail.org>
	<20090720135844.GA16844@infradead.org>
	<4A648718.9000709@shipmail.org>
	<20090720161620.7b027f8d@lxorguk.ukuu.org.uk>
	<20090720155226.GA27885@srcf.ucam.org>
	<20090720155745.GB12536@infradead.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Greg still claims that qcserial could be used by rebooting from Windows,
> right?  In that it would still be extremly borderline to me, but it's

qcserial has a firmware loader app nowdays (someone wrote one in April)

http://www.codon.org.uk/~mjg59/gobi_loader/

indeed Matthew wrote it 8)
