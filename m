Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYAQEvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYAQEvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 23:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYAQEv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 23:51:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYAQEv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 23:51:28 -0500
Date: Wed, 16 Jan 2008 20:55:12 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.23.14
Message-ID: <20080117045512.GA9847@kroah.com>
References: <20080114211012.GC3051@kroah.com> <20080116142741.GB3987@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116142741.GB3987@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 03:27:41PM +0100, markus reichelt wrote:
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > It contains a single fix for a problem that could cause a local
> > user to cause file system corruption on some types of filesystems.
> 
> Some types of filesystems? Which ones? 

Lots of them, but not all :)
