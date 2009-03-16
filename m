Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZCPNKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZCPNKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZCPNKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:10:03 -0400
Received: from verein.lst.de ([213.95.11.210]:51380 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZCPNKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:10:01 -0400
Date: Mon, 16 Mar 2009 14:09:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-m68k@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 4/7] parisc: rtc: Rename rtc-parisc to rtc-generic
Message-ID: <20090316130916.GA3324@lst.de>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 02:26:20PM +0100, Geert Uytterhoeven wrote:
> The rtc-parisc driver is not PA-RISC specific at all, as it uses the existing
> (but deprecated) generic RTC infrastructure ([gs]et_rtc_time()).
> Rename the driver from rtc-parisc to rtc-generic.

Maybe it should be called rtc-legacy instead?

