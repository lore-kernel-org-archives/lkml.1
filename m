Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZBYGY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZBYGY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZBYGYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:24:48 -0500
Received: from kroah.org ([198.145.64.141]:52608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291AbZBYGYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:24:47 -0500
Date: Tue, 24 Feb 2009 22:00:03 -0800
From: Greg KH <greg@kroah.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging: ! x & y problem in inactive code
Message-ID: <20090225060003.GB13931@kroah.com>
References: <499D3639.3080109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499D3639.3080109@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 11:36:41AM +0100, Roel Kluin wrote:
> This is the only ! x & y problem I found that weren't already reported,
> except by me in http://lkml.org/lkml/2009/1/17/69 but maybe you
> overlooked it?

Sorry, got it now, they should all be fixed up, right?

thanks,

greg k-h
