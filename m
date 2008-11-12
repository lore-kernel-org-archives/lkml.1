Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYKLXUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYKLXUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKLXT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:19:56 -0500
Received: from kroah.org ([198.145.64.141]:42317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYKLXT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:19:56 -0500
Date: Wed, 12 Nov 2008 14:25:02 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] [STAGING] Always register wlan-ng driver
Message-ID: <20081112222502.GA27479@kroah.com>
References: <1225406912-18376-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225406912-18376-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 01:48:32AM +0300, Dmitry Baryshkov wrote:
> Currently wlan-ng driver registration is under #ifdef MODULE.
> Register the wlan-ng driver even if it's built-in into the kernel.

Sorry, someone already beat you to this cleanup :(

thanks,

greg k-h
