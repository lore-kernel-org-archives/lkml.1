Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXKJPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXKJPlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXKJPlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:41:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbXKJPlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:41:15 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 2/13] Char: nozomi, expand some functions
Date: Sat, 10 Nov 2007 16:41:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <457510094309335479.slaby@pripojeni.net>
In-Reply-To: <457510094309335479.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101641.12762.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:44:10, you (Jiri Slaby) wrote:
> nozomi, expand some functions
> 
> nozomi_setup_interrupt and tty_do_close are used only in one place and has
> no pros of being in separate functions. 

definitely true, all apllied without change

Thanks,
Frank


