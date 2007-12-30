Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXL3XXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXL3XXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 18:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXL3XWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 18:22:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48001 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXL3XWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 18:22:55 -0500
Date: Mon, 31 Dec 2007 00:22:54 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jose de la Mancha <hidalgoj@free.fr>
cc: linux-kernel@vger.kernel.org
Subject: Re: RAID timeout parameter accessibility request
In-Reply-To: <C39DDD66.F5A0%hidalgoj@free.fr>
Message-ID: <Pine.LNX.4.64.0712310021220.2093@fbirervta.pbzchgretzou.qr>
References: <C39DDD66.F5A0%hidalgoj@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 30 2007 23:42, Jose de la Mancha wrote:
>SHORT QUESTION :
>In a Debian-controlled RAID array, is there a parameter that handles the
>timeout before a non-responding drive is dropped from the array ? Can this
>timeout become user-adjustable in a future build ?

Not sure about Debian,

but perhaps /sys/block/md0/md/safe_mode_delay does something?

