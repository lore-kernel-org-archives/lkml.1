Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbYBHH2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbYBHH2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbYBHH2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:28:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:60781 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895AbYBHH2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:28:36 -0500
Date: Fri, 8 Feb 2008 08:28:34 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
       Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [RFT 1/1] single_chip test
Message-ID: <20080208072834.GA19698@dose.home.local>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com> <20080206150043.GA6921@nineveh.local> <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com> <20080207212529.GA5975@dose.home.local> <47AB7D48.2020805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB7D48.2020805@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 22:51:04 +0100, Jiri Slaby wrote:

[...]

> What's the srev a phy ver printed few lines above this, please?

ath5k_pci 0000:02:00.0: registered as 'phy0'
SINGLE: 1, srev: a3, phy:
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)

Regards,
Tino
