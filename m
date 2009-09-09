Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZIITVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZIITVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZIITVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZIITVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:21:31 -0400
Date: Wed, 9 Sep 2009 15:20:03 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090909152003.75b8eecf@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090909183640.GA17027@suse.de>
References: <20090909030843.GC10608@suse.de>
	<20090909073150.44F8C12B5F@gandalf.tls.msk.ru>
	<20090909132340.GA12391@suse.de>
	<20090909182802.GA12456@mail.oracle.com>
	<20090909183640.GA17027@suse.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 11:36:40 -0700
Greg KH <gregkh@suse.de> wrote:

> 
> Very wierd.  I used the same patch to pick from :(
> 
> I'll go fix this up and do a new release for the .27 tree.  Thanks for
> working it out for me.
> 

I diagnosed this and sent the fix to you on Saturday:

http://patchwork.kernel.org/patch/45946
