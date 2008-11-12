Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYKLXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYKLXUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYKLXT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:19:57 -0500
Received: from kroah.org ([198.145.64.141]:42318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753499AbYKLXT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:19:57 -0500
Date: Wed, 12 Nov 2008 14:30:24 -0800
From: Greg KH <greg@kroah.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] p80211netdev.c correctly enable wext handlers
Message-ID: <20081112223024.GB27479@kroah.com>
References: <1225710353.3113.5.camel@castor.localdomain> <1225711103.3113.22.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225711103.3113.22.camel@castor.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 11:18:23AM +0000, Richard Kennedy wrote:
> correctly enable wext handlers
> CONFIG_NET_WIRELESS does not exist so wext_handlers did not get
> defined. 

This patch had already been applied to my tree from someone else.

thanks,

greg k-h
