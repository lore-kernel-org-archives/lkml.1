Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZBQKdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZBQKdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZBQKd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:33:29 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44462 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZBQKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:33:28 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Laurent Riffard <laurent.riffard@free.fr>, linux-input@vger.kernel.org
Subject: Re: linux-next: USB mouse won't work after resume.
Date: Tue, 17 Feb 2009 11:35:11 +0100
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <499A89AD.6010704@free.fr>
In-Reply-To: <499A89AD.6010704@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171135.13329.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.

Please recompile your kernel with CONFIG_USB_DEBUG and
send me your dmesg.

	Regards
		Oliver

