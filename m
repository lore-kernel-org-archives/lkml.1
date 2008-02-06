Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbYBFVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbYBFVOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYBFVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:14:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39190 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbYBFVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:14:31 -0500
Date: Wed, 6 Feb 2008 22:14:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gilles Espinasse <g.esp@free.fr>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only 
In-Reply-To: <1201877107.47a3307340b38@imp.free.fr>
Message-ID: <Pine.LNX.4.64.0802062204410.23855@fbirervta.pbzchgretzou.qr>
References: <1201877107.47a3307340b38@imp.free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2008 15:45, Gilles Espinasse wrote:
>..
>> There are no known closed source USB drivers in the wild, so this
>> patch should cause no problems.
>
>There is the unicorn usb adsl modem driver (STM unicorn chip).
>http://www.bewan.com/bewan/drivers/A1012-A1006-A904-A888-A983-0.9.3.tgz
>There is some sources and a binary blob to be linked.
>
>The only things I know from the binary blob is that sources should be 150 000
>lines of C++.

It's 63 C++ files actually (wow, that even beats the blob-iness of nvidia!)
and a few files look rather empty. Their source would rather benefit
from getting a review on LKML.
