Return-Path: <linux-kernel-owner+w=401wt.eu-S937081AbXFGVRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937081AbXFGVRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935246AbXFGVRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:17:22 -0400
Received: from khc.piap.pl ([195.187.100.11]:50420 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935198AbXFGVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:17:22 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 07 Jun 2007 23:17:18 +0200
In-Reply-To: <20070607162251.5f291325@the-village.bc.nu> (Alan Cox's message of "Thu, 7 Jun 2007 16:22:51 +0100")
Message-ID: <m3wsyfzcpt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> The intel-rng printed a nice well formatted message when the port was
> disabled. Someone then came along and blindly trashed it by screwing up a
> trim down to 80 columns.

Perhaps we should drop that 80-column style and use some 120+?
X or no X, almost all people now have more lines and columns on their
displays than MDA 20 years ago.

132 to match text VGA perhaps?
80 can be left for the actual _output_, I mean number of chars printed
by kernel code.
-- 
Krzysztof Halasa
