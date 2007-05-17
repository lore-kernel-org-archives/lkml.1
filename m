Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbXEQPE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbXEQPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXEQPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:04:21 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58575 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbXEQPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:04:20 -0400
Date: Thu, 17 May 2007 11:04:20 -0400
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Rob Landley <rob@landley.net>, Tejun Heo <htejun@gmail.com>,
       Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070517150420.GA10008@csclub.uwaterloo.ca>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705161948.56497.rob@landley.net> <20070517005842.GC600@khazad-dum.debian.net> <200705162305.11755.rob@landley.net> <20070517033947.GA24757@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517033947.GA24757@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:39:47AM -0300, Henrique de Moraes Holschuh wrote:
> Actually, in my limited experience, SAS is marginally less crappy than SATA,
> and has a higher MTBF, probably because the manufacturers try to cut less
> corners.  But if one can get high-quality SATA drives (where?!), I don't
> know why SAS would be superior to SATA.

SAS is dual ported so you can have redundant cables and controllers.

--
Len Sorensen
