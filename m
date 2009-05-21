Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZEUQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZEUQ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZEUQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:57:53 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:46620 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZEUQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:57:53 -0400
Date: Thu, 21 May 2009 18:57:51 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
Message-ID: <20090521165751.GA4428@geggus.net>
References: <20090521142026.GA5566@geggus.net> <1242924599.6687.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242924599.6687.1.camel@heimdal.trondhjem.org>
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust schrieb am Donnerstag, den 21. Mai um 18:49 Uhr:

> I can't find any such error message in the kernel.

The message seems to come from fs/exportfs/expfs.c

> Is this the userland NFS server?

No, its not!

Sven

-- 
If we want hardware to work to its full potential, we need to claim to
be a recent version of Windows. (Matthew Garrett)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
