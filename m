Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXCVIum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXCVIum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXCVIul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:50:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965880AbXCVIul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:50:41 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Date: Thu, 22 Mar 2007 09:50:29 +0100
User-Agent: KMail/1.9.1
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
References: <20070321204752.GA5125@dose.home.local>
In-Reply-To: <20070321204752.GA5125@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703220950.29445.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. März 2007 21:47 schrieb Tino Keitel:

> along with other USB error messages. I tried a hub with own power
> supply and a USB port on the computer. A full log is attached.

Your log basically shows a hub going berserk. Please post "lsusb -v"
and your .config

	Regards
		Oliver
