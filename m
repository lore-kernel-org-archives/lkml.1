Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZCNEFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZCNEFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZCNEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:05:08 -0400
Received: from kroah.org ([198.145.64.141]:50937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750716AbZCNEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:05:07 -0400
Date: Fri, 13 Mar 2009 20:48:52 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Message-ID: <20090314034852.GA3417@kroah.com>
References: <20090310112307.GD1337@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310112307.GD1337@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:23:07PM +0100, Pavel Machek wrote:
> Hi!
> 
> Since switch to 2.6.29-rc, bluetooth crashes system... usually on
> disconnect or killall pppd.

Do we have a trace?
