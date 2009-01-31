Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZAaWKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZAaWKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 17:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZAaWK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 17:10:28 -0500
Received: from fifo99.com ([67.223.236.141]:49853 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZAaWK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 17:10:28 -0500
Subject: Re: checkpatch.pl is getting too slow
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1233437719.5903.33.camel@desktop>
References: <20090131185507.GA3280@kroah.com>
	 <20090131210220.GA25811@shadowen.org>  <1233437719.5903.33.camel@desktop>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 14:10:23 -0800
Message-Id: <1233439823.5903.38.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 13:35 -0800, Daniel Walker wrote:

> 
> The way your doing updates makes bisecting this code way too difficult..
> I bisected this down to the commit for version 0.15 , but if you had all
> the 0.15 patches as discrete git commits I could have actually found the
> specific patch causing the problem ..
> 
> Could you start doing one fix or change per git commit?

My mistake , it looks like you are now .. 0.15 was a while ago I guess..
It looks like 0.15 isn't the problem after all, it only makes it slower
not extremely slow..

Daniel

