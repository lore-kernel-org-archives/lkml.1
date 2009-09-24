Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZIXTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZIXTCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZIXTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:02:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39816 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZIXTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:02:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Date: Thu, 24 Sep 2009 21:03:47 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost>
In-Reply-To: <20090924154023.GA27480@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909242103.48562.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. September 2009 17:40:23 schrieb Johan Hovold:
> Is there a reason why this was not fixed in ftdi_sio (and whiteheat?)
> along with the other drivers?

No good reason. They escaped my grep pattern. Mea culpa.

	Regards
		Oliver

