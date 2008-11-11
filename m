Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYKKHSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYKKHSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYKKHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:18:29 -0500
Received: from kroah.org ([198.145.64.141]:58561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754757AbYKKHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:18:27 -0500
Date: Mon, 10 Nov 2008 23:14:20 -0800
From: Greg KH <greg@kroah.com>
To: Andrey Vul <andrey.vul@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about CardBus support and ExpressCard?
Message-ID: <20081111071420.GC13596@kroah.com>
References: <e38d12ff0811101834u46065e0ft13325cbb0104f36b@mail.gmail.com> <e38d12ff0811101836s6f1d9449v4c210f2b83169e46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38d12ff0811101836s6f1d9449v4c210f2b83169e46@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 09:36:57PM -0500, Andrey Vul wrote:
> On Mon, Nov 10, 2008 at 21:34, Andrey Vul <andrey.vul@gmail.com> wrote:
> > I'm configuring 26.27.2 right now and my laptop supports ExpressCard
> > but not CardBus?
> > Do I still need CardBus kernel support for the ExpressCard slot to
> > function properly?
> Apart from PCI Express hotplug.

No, you should not.

good luck,

greg k-h
