Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZGUNG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZGUNG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZGUNGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:06:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60207 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZGUNGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:06:24 -0400
Date: Tue, 21 Jul 2009 14:06:18 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch whitespace
Message-ID: <20090721130618.GP12122@shadowen.org>
References: <20090721100113.GC4133@elf.ucw.cz>
 <200907221305.28115.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907221305.28115.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 01:05:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 21 July 2009 12:01:14 Pavel Machek wrote:
> 
> > Would it be possible to add autofixing to checkpatch? Fixing
> > whitespace issues by hand is useless & boring task...
> 
> That's why most people use scripts for it.. ;)
> 
> scripts/cleanfile
> scripts/cleanpatch
> 
> Maybe we should make checkpatch inform people about them
> (if any whitespace errors were detected)..

That sounds like a good idea.  Will have a look at doing that.

-apw
