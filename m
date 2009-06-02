Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZFBOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZFBOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZFBOeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:34:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35233 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752499AbZFBOeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:34:02 -0400
Date: Tue, 2 Jun 2009 15:35:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Subject: Re: [PATCH 08/10] tty_io: export tty_class
Message-ID: <20090602153508.45e57292@lxorguk.ukuu.org.uk>
In-Reply-To: <20090602142241.GA18656@doriath.ww600.siemens.net>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-5-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-6-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-9-git-send-email-dbaryshkov@gmail.com>
	<20090601160721.7b262469@lxorguk.ukuu.org.uk>
	<bc64b4640906010810l8ace77byfbd650b549f9b5c3@mail.gmail.com>
	<20090601163418.465be751@lxorguk.ukuu.org.uk>
	<20090602142241.GA18656@doriath.ww600.siemens.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes - create a proper tty helper function for doing the job and document
> > what it does. That way if the tty layer is changed it is obvious that
> > this code also needs considering.
> 
> Is this suitable:

Perfect - add the needed documentation to the public function and submit
it for merging.

Alan
