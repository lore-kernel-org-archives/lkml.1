Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYBHQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYBHQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbYBHQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:34:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47029 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYBHQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:34:08 -0500
Date: Fri, 8 Feb 2008 08:31:08 -0800
From: Greg KH <greg@kroah.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBI: add mtd_num sysfs attribute
Message-ID: <20080208163108.GE16477@kroah.com>
References: <200802071907.m17J7eYA022058@hera.kernel.org> <20080208054743.GA13097@kroah.com> <47AC1205.5070907@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC1205.5070907@nokia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:25:41AM +0200, Artem Bityutskiy wrote:
> Greg KH wrote:
>> Can you please add this information to Documentation/ABI/ so that people
>> know what is going on here?
>
> Sent you the patch (Subject: [PATCH] Documentation: add UBI sysfs ABI 
> docs).

Thanks, looks good.

> I assume you'll put it into your tree and take the further care of it, 
> right?

No, it needs to go through the same path that your other UBI patches
went through.  Can you do that?

thanks,

greg k-h
