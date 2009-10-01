Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZJAO32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZJAO32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932661AbZJAO30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:29:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:53466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbZJAO3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:29:24 -0400
Date: Thu, 1 Oct 2009 07:25:08 -0700
From: Greg KH <gregkh@suse.de>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference / tty subsystem? / 2.6.31.1/ still
 persists, in stable .1 release too
Message-ID: <20091001142508.GB3546@suse.de>
References: <200910011244.01851.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011244.01851.denys@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 12:44:01PM +0300, Denys Fedoryschenko wrote:
> Kernel 2.6.31.1

2.6.31.1 still has a number of tty problems.  I'm working through all of
the patches right now to hopefully have 2.6.31.2 fixed in this area.

thanks,

greg k-h
