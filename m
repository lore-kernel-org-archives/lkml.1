Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXKJPpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXKJPpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKJPni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:43:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:51452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbXKJPnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:43:37 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 12/13] Char: nozomi, remove void acc char2 char3 more mp mp.c mp.yy m1 nozomi2 proto rej slock1 casts
Date: Sat, 10 Nov 2007 16:43:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <18101143033031832003.slaby@pripojeni.net>
In-Reply-To: <18101143033031832003.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101643.35262.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:50:53, you (Jiri Slaby) wrote:
> nozomi, remove void * casts

Yes, they are of course pointless. Applied your patch
without changes.

Thanks,
Frank
