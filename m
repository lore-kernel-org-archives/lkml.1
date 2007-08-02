Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbXHBLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbXHBLDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXHBLDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:03:30 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:33354 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418AbXHBLDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:03:30 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 07:03:29 EDT
Date: Thu, 2 Aug 2007 18:54:37 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Mattia Dongili <malattia@linux.it>
Cc: Thomas Renninger <trenn@suse.de>, Eugene Teo <eugeneteo@kernel.sg>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/sonypi.c: fix ids member of struct
	acpi_driver
Message-ID: <20070802105437.GA4564@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070801091534.GA6845@kernel.sg> <20070802064034.GF25969@inferi.kami.home> <1186041019.18821.399.camel@queen.suse.de> <20070802075921.GJ25969@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802075921.GJ25969@inferi.kami.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattia,

<quote sender="Mattia Dongili">
> On Thu, Aug 02, 2007 at 09:50:18AM +0200, Thomas Renninger wrote:
> > On Thu, 2007-08-02 at 15:40 +0900, Mattia Dongili wrote:
> > > On Wed, Aug 01, 2007 at 05:15:34PM +0800, Eugene Teo wrote:
> > > > ids member of struct acpi_driver is of type struct acpi_device_id, not a
> > > > character array.
> > > > 
> > > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
[...]

> yep, sony-laptop will replace sonypi. It still has some problems but
> development is progressing in sony-laptop, not sonypi.
> 
> Eugene, I'll import the patch without the MODULE_DEVICE_TABLE line.

Ok, thanks.

Eugene

