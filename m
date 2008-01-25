Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYAYI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYAYI4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYAYI4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:56:06 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:48569 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYAYI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:56:05 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Fri, 25 Jan 2008 09:58:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Wilco Beekhuizen <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <200801242100.22090.oliver@neukum.org> <20080124202833.GA3216@kroah.com>
In-Reply-To: <20080124202833.GA3216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250958.57917.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 21:28:33 schrieb Greg KH:
> And if you see problems in the usbfs implementation with regards to
> lifetime rules (becides the devices file), please let me know.

All looks sane.

	Regards
		Oliver

