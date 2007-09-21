Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbXIUTr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbXIUTr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbXIUTrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:47:18 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:43625 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbXIUTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:47:17 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive leds
Date: Fri, 21 Sep 2007 21:47:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46F3C704.5000203@hhs.nl> <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz> <46F3D326.6050804@hhs.nl>
In-Reply-To: <46F3D326.6050804@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212147.57978.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 21 September 2007 schrieb Hans de Goede:
> Thats not what I had in mind, autosuspend doesn't work (presumably because hal 
> keeps polling for media change) maybe I should fix hal to not keep polling for 
> devices which don't have removable media?

If you find a way to tell which devices fall into that class.

	Regards
		Oliver

