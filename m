Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbZBKQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbZBKQIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbZBKQIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:08:36 -0500
Received: from kroah.org ([198.145.64.141]:46061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756511AbZBKQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:08:35 -0500
Date: Tue, 10 Feb 2009 19:16:19 -0800
From: Greg KH <greg@kroah.com>
To: Michael Friedl <linux@nicce.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: duplicate usb device ids
Message-ID: <20090211031619.GA17040@kroah.com>
References: <49920CA6.603@nicce.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49920CA6.603@nicce.at>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 12:24:22AM +0100, Michael Friedl wrote:
> I got a new CCD 800B barcode scanner, but it has the same device id like an 
> other product from Tenx, which is on the ignore list for hid devices.
>
> Found nothing about the old product so I report it here.
> If the old one get removed from the ignore list the bardcode scanner works 
> perfect!
>
> Im not sure how to handle duplicate ids..

Let the HID maintainer know, he should probably just remove these ignore
values now that the manufacturer has fixed the device.

thanks,

greg k-h
