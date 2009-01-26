Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZAZIil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZAZIil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbZAZIid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:38:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37543 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZAZIic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:38:32 -0500
Date: Mon, 26 Jan 2009 08:38:30 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch vs. checkpatch --file (was: Re: [Orinoco-devel]
	[PATCH] orinoco: checkpatch cleanup)
Message-ID: <20090126083830.GA17399@shadowen.org>
References: <200901252254.32137.arvidjaar@mail.ru> <200901252308.45889.arvidjaar@mail.ru> <1232941562.1604.4.camel@dv> <200901260713.39734.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901260713.39734.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 07:13:36AM +0300, Andrey Borzenkov wrote:
> On 26 января 2009 06:46:02 Pavel Roskin wrote:
> >
> > Please run the patch itself through checkpatch.  It finds two errors:
> >
> > ERROR: trailing statements should be on next line
> > #163: FILE: drivers/net/wireless/orinoco/hermes.c:65:
> > +                       printk(stuff); } while (0)
> > +                       printk(stuff); } while (0)
> 
> I ran "checkpatch --file hermes.c" after editing it and it found zero 
> errors.
> 
> Cc checkpatch maintainer.

Hmmm.  Could I have the patch and the file either before or after
application please.

Very strange.

-apw
