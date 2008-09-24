Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYIXUo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYIXUo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXUoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:44:21 -0400
Received: from 1wt.eu ([62.212.114.60]:4472 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYIXUoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:44:21 -0400
Date: Wed, 24 Sep 2008 22:33:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       bernhard.weirich@riedel.net
Subject: Re: [1/1] w1: new driver. DS2431 chip.
Message-ID: <20080924203329.GG24654@1wt.eu>
References: <20080917154928.GB490@2ka.mipt.ru> <20080917160007.1fc58f28.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917160007.1fc58f28.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 04:00:07PM -0700, Andrew Morton wrote:
> > +/*
> > + *	w1_DS2431.c - w1 family 2d (DS2431) driver
> 
> case-insensitive filenames? ;)

Also it would be kind to add one line indicating what this chip does.
I had to read till the last line to discover it's a 1kb EEPROM.

Willy

