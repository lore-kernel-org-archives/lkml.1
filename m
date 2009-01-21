Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZAUSJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZAUSJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZAUSIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:08:42 -0500
Received: from kroah.org ([198.145.64.141]:42458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754969AbZAUSIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:08:41 -0500
Date: Wed, 21 Jan 2009 09:47:15 -0800
From: Greg KH <greg@kroah.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: fix !x & y
Message-ID: <20090121174715.GF3991@kroah.com>
References: <4971FDCC.9090503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4971FDCC.9090503@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 04:48:28PM +0100, Roel Kluin wrote:
> ! has a higher precedence than &
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Sorry, someone already beat you to this change :(

thanks,

greg k-h
