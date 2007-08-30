Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbXH3Trt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbXH3Trt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760304AbXH3Trl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:47:41 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34788 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760092AbXH3Trk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:47:40 -0400
Date: Thu, 30 Aug 2007 15:47:40 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, dex@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Message-ID: <20070830194740.GC11130@csclub.uwaterloo.ca>
References: <200708300731.20336.a1426z@gawab.com> <20070830110144.1e8020ec@the-village.bc.nu> <200708301654.22346.a1426z@gawab.com> <Pine.LNX.4.64.0708302135560.24730@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708302135560.24730@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 09:38:23PM +0200, Jan Engelhardt wrote:
> Hard to tell, since some (most?) laptops have sort of a backplane and there
> might be no real cable you could see because it's all mainboard wire paths
> already.

Makes you wonder why the mainboard doesn't just pretend to be an 80 wire
cable if that is what it is compatible with.  Seems like a design flaw
in the laptop to not do so.

--
Len Sorensen
