Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXERHUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXERHUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbXERHUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:20:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40446
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXERHUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:20:36 -0400
From: Rob Landley <rob@landley.net>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Fri, 18 May 2007 03:16:45 -0400
User-Agent: KMail/1.9.1
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <htejun@gmail.com>,
       Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <20070517033947.GA24757@khazad-dum.debian.net> <20070517150420.GA10008@csclub.uwaterloo.ca>
In-Reply-To: <20070517150420.GA10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705180316.45969.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 11:04 am, Lennart Sorensen wrote:
> On Thu, May 17, 2007 at 12:39:47AM -0300, Henrique de Moraes Holschuh wrote:
> > Actually, in my limited experience, SAS is marginally less crappy than 
SATA,
> > and has a higher MTBF, probably because the manufacturers try to cut less
> > corners.  But if one can get high-quality SATA drives (where?!), I don't
> > know why SAS would be superior to SATA.
> 
> SAS is dual ported so you can have redundant cables and controllers.

Because the controller's far more likely to go than the moving parts...

On the models I saw they also literally gold plated the connectors, spun the 
disks faster, and basically did everything they could think of to make the 
same basic bundle of components more expensive.  (Of course the fundamental 
thing you do to make it more expensive is have smaller production runs in the 
first place...)

Rob
