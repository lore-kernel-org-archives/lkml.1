Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbXFNQnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbXFNQnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXFNQm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:42:57 -0400
Received: from lazybastard.de ([212.112.238.170]:39588 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbXFNQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:42:56 -0400
Date: Thu, 14 Jun 2007 18:38:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, maxdamage@aladin.ro
Subject: Re: ext2 on flash memory
Message-ID: <20070614163803.GA31984@lazybastard.org>
References: <466D379C.6000809@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466D379C.6000809@wpkg.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 June 2007 13:53:00 +0200, Tomasz Chmielewski wrote:
> 
> jffs2 only works on mtd devices, and that excludes pendrives, which are 
> block devices. I know LogFS will work with block devices one day, but 
> currently, it doesn't (and is not in the kernel yet as well).

Actually, LogFS does work on block devices now.  Performance on hard
disks is quite bad.  Hopefully that becomes untrue just as fast as your
slightly outdated claim. :)

Jörn

-- 
Measure. Don't tune for speed until you've measured, and even then
don't unless one part of the code overwhelms the rest.
-- Rob Pike
