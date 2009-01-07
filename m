Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbZAGTlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbZAGTlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZAGTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:40:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:53072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbZAGTkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:40:51 -0500
Date: Wed, 7 Jan 2009 11:36:25 -0800
From: Greg KH <gregkh@suse.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 53/60] avr: struct device - replace bus_id with
	dev_name(), dev_set_name()
Message-ID: <20090107193625.GA19027@suse.de>
References: <20090106221123.GA32689@kroah.com> <1231279939-32728-53-git-send-email-gregkh@suse.de> <20090107095436.30313d5b@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107095436.30313d5b@hskinnemoen-d830>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 09:54:36AM +0100, Haavard Skinnemoen wrote:
> Greg Kroah-Hartman wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> I just applied the original patch. Thanks for keeping track of it in
> the mean time :)

It's now in Linus's tree, so you don't have to keep track of it at all
anymore :)

thanks,

greg k-h
