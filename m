Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYDHNwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYDHNwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYDHNwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:52:13 -0400
Received: from lazybastard.de ([212.112.238.170]:52184 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYDHNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:52:13 -0400
Date: Tue, 8 Apr 2008 15:52:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 1/15] Makefiles and Kconfig
Message-ID: <20080408135203.GB670@logfs.org>
References: <20080401181308.512473173@logfs.org> <200804080230.17426.arnd@arndb.de> <20080408083316.GA31262@logfs.org> <200804081542.00333.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804081542.00333.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 April 2008 15:41:59 +0200, Arnd Bergmann wrote:
> On Tuesday 08 April 2008, Jörn Engel wrote:
> > "Logfs file system" might make sense.  LOGFS_FS is something I would
> > rather avoid.  For some reason my brain reacts strongly to repetition,
> > redundancy and superfluous information.
> > 
> 
> How about LOG_FS then? I don't think there is a really good argument
> either way, but a large majority uses the *_FS notation in Kconfig.

Fair enough.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
