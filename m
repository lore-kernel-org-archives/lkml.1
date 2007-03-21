Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXCUXDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXCUXDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXCUXDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:03:10 -0400
Received: from eazy.amigager.de ([213.239.192.238]:53217 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXCUXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:03:08 -0400
Date: Thu, 22 Mar 2007 00:01:43 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc suspend regression
Message-ID: <20070321230143.GA29112@thinkpad.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1174517644.5633.31.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174517644.5633.31.camel@funkylaptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 23:54:04 +0100, Frédéric RISS wrote:
> My MacMini (Intel Core Duo, EFI mode) doesn't come out of suspend to ram

I tested suspend to RAM today with my mini. It also failed to resume.
I don't use EFI but boot via GRUB.

Regards,
Tino
