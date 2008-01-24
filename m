Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYAXLqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYAXLqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYAXLqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:46:21 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:51344 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYAXLqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:46:20 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Thu, 24 Jan 2008 12:49:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com> <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
In-Reply-To: <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241249.06577.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 12:19:25 schrieb Pekka Enberg:
> AFAICT the whole thing should be a proper USB driver in drivers/usb/
> and not a "filesystem" in fs/

A quick glance through the files at sourceforge indicates that this
device use a file transfer protocol. Mapping this to a simple device
is hard. A fs is quite natural a representation of that.

	Regards
		Oliver
