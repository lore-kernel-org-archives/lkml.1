Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXLDRX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXLDRX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXLDRXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:23:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:56111 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbXLDRXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:23:20 -0500
From: David Sterba <dsterba@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Date: Tue, 4 Dec 2007 18:23:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jeff@garzik.org, jkosina@suse.cz,
       jslaby@suse.cz, stephen@symmetric.co.nz, benm@symmetric.co.nz
References: <20071130125555.GA10977@ds.suse.cz> <1196505933.12292.58.camel@violet>
In-Reply-To: <1196505933.12292.58.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041823.11025.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> can we please drop the stupid "_cs" stuff. It is an old habit to have
> the shortcut for "Card Services" in the driver name, but that goes back
> to the time when the PCMCIA subsystem and its drivers were an external
> package. Especially in cases where only a PCMCIA card exists, it makes
> no sense anymore.

ok, will drop it, thanks.
Dave
