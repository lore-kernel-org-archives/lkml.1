Return-Path: <linux-kernel-owner+w=401wt.eu-S1767251AbXDEUjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767251AbXDEUjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767304AbXDEUjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:39:06 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48492 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767251AbXDEUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:39:05 -0400
Date: Thu, 5 Apr 2007 22:37:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: IRQ splitting
In-Reply-To: <20070405122341.482f5e26@freekitty>
Message-ID: <Pine.LNX.4.61.0704052236110.6042@yvahk01.tjqt.qr>
References: <fa.21iotKLTgoLpkKhrbSxrjy5v7hM@ifi.uio.no> <46150913.4000406@shaw.ca>
 <20070405122341.482f5e26@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Apr 5 2007 12:23, Stephen Hemminger wrote:
>
>If the radeon and/or the Ethernet driver support MSI, that would split
>out the IRQ's as well.

Would Linux do that automatically? How to find out whether a given
device -- or device driver? -- supports MSI?


Thanks,
Jan
-- 
