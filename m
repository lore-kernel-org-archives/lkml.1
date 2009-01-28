Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZA1RwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZA1RwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZA1Rv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:51:59 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:50859 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZA1Rv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:51:59 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Michelle Konzack <linux4michelle@tamay-dogan.net>
Subject: Re: System hang (and other problems) with cdc_acm
Date: Wed, 28 Jan 2009 18:52:33 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com> <200901281144.38800.oliver@neukum.org> <20090128172819.GH4166@tamay-dogan.net>
In-Reply-To: <20090128172819.GH4166@tamay-dogan.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901281852.33742.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 28 January 2009 18:28:19 schrieb Michelle Konzack:
> Am 2009-01-28 11:44:38, schrieb Oliver Neukum:
> > Am Wednesday 28 January 2009 10:16:01 schrieb Michelle Konzack:
> > > Am 2009-01-26 13:47:57, schrieb Oliver Neukum:
> > > > Please be specific. Does your internet connection hang, or does the
> > > > whole system hang?
> > > 
> > > The whole system...  If I can not get a webpage on my workstation I  try
> > > to connect to my router using ssh but the xterm close  immeiately  which
> > > mean, the system is entirely crashed
> > 
> > Is the system you are referring to on your workstation or your router?
> 
> The router of course...

Ok, I see. You can see your hardware while you type. I cannot.
Please compile your router a kernel with CONFIG_PROVE_LOCKING and
CONFIG_DETECT_SOFTLOCKUP

	Regards
		Oliver
