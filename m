Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZG1TVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZG1TVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZG1TVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:21:16 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:52895 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZG1TVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:21:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the usb.current tree
Date: Tue, 28 Jul 2009 21:21:32 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au> <20090728163222.GA14899@kroah.com> <20090728163420.GB14899@kroah.com>
In-Reply-To: <20090728163420.GB14899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282121.33231.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 28. Juli 2009 18:34:20 schrieb Greg KH:
> > > Oliver: I'll send you an alternative patch later today/tomorrow that
> > > uses the ASYNC flags.
> >
> > Should I just drop Oliver's existing patch from my tree for now then?
>
> Ok, in order to get a good merge for today, I've dropped it now.
>
> Oliver, care to work with Alan to get something that is agreeable to
> everyone?

Sure. Alan, is there a driver you can recommend for looking at to learn how
to correctly use the tty layer?

	Regards
		Oliver

