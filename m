Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZHSQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZHSQga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZHSQga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:36:30 -0400
Received: from kroah.org ([198.145.64.141]:47166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZHSQg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:36:29 -0400
Date: Wed, 19 Aug 2009 09:34:39 -0700
From: Greg KH <greg@kroah.com>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
Message-ID: <20090819163439.GA3094@kroah.com>
References: <1250665599.4545.3.camel@localhost>
 <20090819154437.GA729@kroah.com>
 <1250698851.4323.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250698851.4323.9.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

On Wed, Aug 19, 2009 at 05:20:51PM +0100, Karl Relton wrote:
> I plan to give the various distributions a utility to pre-compile the
> firmware. It is based on ihex2fw.c.
> 
> I don't think the firmware will ever be accepted into linux-firmware
> because the original licensing cannot be established.

Have you asked the company?
Where is the firmware at today?

thanks,

greg k-h
