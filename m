Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYIVRy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYIVRy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYIVRyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:54:51 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:39994 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYIVRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:54:51 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Date: Mon, 22 Sep 2008 18:54:44 +0100
User-Agent: KMail/1.9.9
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
References: <200809211853.19889.carlos@strangeworlds.co.uk> <20080922155949.GA4283@kroah.com>
In-Reply-To: <20080922155949.GA4283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221854.44615.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 22 Sep 2008 17:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2008 16:59:49 Greg KH wrote:
> On Sun, Sep 21, 2008 at 06:53:19PM +0100, Carlos Corbacho wrote:
> > On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> > > This patch fixes these bugs by using platform_device_register_simple()
> >
> > [Adding Greg KH to CC - 2nd time lucky...]
> >
> > Last I heard, platform_device_register_simple() was in the process of
> > being deprecated and then slated for future removal. Has this changed?
>
> I don't recall this, but someone else might have stated it a while ago.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-04/msg02070.html

This was dated a while ago, but has anything changed since then?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
