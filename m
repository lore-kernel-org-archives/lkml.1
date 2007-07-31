Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXGaOaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXGaOaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbXGaOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:30:22 -0400
Received: from zaphod.dth.net ([85.159.112.68]:34656 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbXGaOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:30:20 -0400
Date: Tue, 31 Jul 2007 16:30:18 +0200
From: Danny ter Haar <dth@dth.net>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Update: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not:
Message-ID: <20070731143017.GA24740@dth.net>
References: <20070727193832.GA20289@dth.net> <46AC0F6E.2000008@googlemail.com> <20070730025412.GA22888@dth.net> <200707301330.54640.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707301330.54640.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Len Brown (lenb@kernel.org):
> Hmmm, okay, the "big hammer" works.  Please see
> if any of these smaller hammers work:
> acpi=noirq

died within 2 minutes

> notsc

After 36 minutes

-- 
