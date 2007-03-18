Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXCRXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXCRXtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXCRXtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:49:19 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39514 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452AbXCRXtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:49:18 -0400
Date: Mon, 19 Mar 2007 00:45:11 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: Arjan van de Ven <arjan@infradead.org>, Mike Snitzer <snitzer@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forced umount?
In-Reply-To: <20070318201305.GA25355@parisc-linux.org>
Message-ID: <Pine.LNX.4.61.0703190044220.20032@yvahk01.tjqt.qr>
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
 <1174245379.3538.252.camel@laptopd505.fenrus.org> <20070318201305.GA25355@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18 2007 14:13, Matthew Wilcox wrote:
>
>Equally, if one has one's ogg collection stored on said NFS server, the
>ogg player will be in uninterruptible sleep while holding the sound device
>open, preventing other applications from making sounds.

Only if you have
  - a card with no hardware mixing or
  - using the obsolete OSS
:)


Jan
-- 
