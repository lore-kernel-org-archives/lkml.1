Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZLDRDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZLDRDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZLDRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:03:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:56628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbZLDRDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:03:34 -0500
Date: Fri, 4 Dec 2009 09:02:52 -0800
From: Greg KH <gregkh@suse.de>
To: Graham Murray <gmurray@webwayone.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 CONFIG_SX marked as BROKEN
Message-ID: <20091204170252.GA2504@suse.de>
References: <7wd42vyp2i.fsf@webwayone.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7wd42vyp2i.fsf@webwayone.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:08:05AM +0000, Graham Murray wrote:
> Commit 412145947adfca60a4b5b4893fbae82dffa25edd marked CONFIG_SX as
> Broken. The commit comments state that there are no users. We are using
> SX cards in production servers. I discovered this when I attempted to
> upgrade a development server to 2.6.32 and it failed to find the cards.

Do you have the ability to test patches to verify changes in order to
help fix up this driver?

Or could you provide a pointer to where I could get one of these cards?
I've been looking for a while and can not seem to find one anywhere.

thanks,

greg k-h
