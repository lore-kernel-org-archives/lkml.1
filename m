Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZGJAd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZGJAd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZGJAdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:33:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54001 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbZGJAdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:33:19 -0400
Date: Fri, 10 Jul 2009 01:34:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: ttydev tree import failure
Message-ID: <20090710013411.32a68454@lxorguk.ukuu.org.uk>
In-Reply-To: <20090710004743.202b36e5@lxorguk.ukuu.org.uk>
References: <20090710091408.67c4da53.sfr@canb.auug.org.au>
	<20090710004743.202b36e5@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed - chuckle

the right patch was there but I forgot to remove the original patch which
for some reason stgit didn't import properly so you had both in the file.
Will push that tomorrow.
