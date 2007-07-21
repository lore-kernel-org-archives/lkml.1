Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXGUVRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXGUVRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbXGUVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:17:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36645 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbXGUVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:17:44 -0400
Date: Sat, 21 Jul 2007 23:17:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lars Ellenberg <lars@linbit.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070721203819.GA10706@mail.linbit.com>
Message-ID: <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr>
References: <20070721203819.GA10706@mail.linbit.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 22:38, Lars Ellenberg wrote:
>
>We implement shared-disk semantics in a shared-nothing cluster.

If nothing is shared, the disk is not shared, but got shared-disk
semantics? A little confusing.


	Jan
-- 
