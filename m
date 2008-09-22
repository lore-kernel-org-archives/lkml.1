Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIVQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIVQT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIVQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:19:13 -0400
Received: from dsl093-040-174.pdx1.dsl.speakeasy.net ([66.93.40.174]:53707
	"EHLO coco.kroah.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbYIVQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:19:11 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 12:19:11 EDT
Date: Mon, 22 Sep 2008 08:59:49 -0700
From: Greg KH <greg@kroah.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Message-ID: <20080922155949.GA4283@kroah.com>
References: <200809211853.19889.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809211853.19889.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 06:53:19PM +0100, Carlos Corbacho wrote:
> On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> > This patch fixes these bugs by using platform_device_register_simple()
> 
> [Adding Greg KH to CC - 2nd time lucky...]
> 
> Last I heard, platform_device_register_simple() was in the process of being 
> deprecated and then slated for future removal. Has this changed?

I don't recall this, but someone else might have stated it a while ago.

sorry,

greg k-h
