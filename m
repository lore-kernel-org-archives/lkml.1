Return-Path: <linux-kernel-owner+w=401wt.eu-S1765558AbYBNUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558AbYBNUWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYBNUWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:22:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYBNUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:22:44 -0500
Date: Thu, 14 Feb 2008 12:20:32 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080214202032.GB16545@kroah.com>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:35:37AM +1100, Stephen Rothwell wrote:
> 
> So, comments, please.

Could you change the Makefile to show that if we build and run this
tree, it really isn't Linus's tree?  Yes, I know the -git number will be
different, but that might not be very obvious to people reading bug
reports on lkml.

Just adding "-next" to the extraversion would be great.

thanks,

greg k-h
