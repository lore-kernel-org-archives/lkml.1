Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbZFQORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbZFQORy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZFQORo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:17:44 -0400
Received: from kroah.org ([198.145.64.141]:52398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZFQORn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:17:43 -0400
Date: Wed, 17 Jun 2009 06:41:01 -0700
From: Greg KH <greg@kroah.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix OOPS in pl2303
Message-ID: <20090617134101.GA11209@kroah.com>
References: <87k53cy697.wl%vmayatsk@redhat.com> <20090616182604.GA28536@kroah.com> <87ws7by73h.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ws7by73h.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 03:36:18AM +0200, Vitaly Mayatskikh wrote:
> At Tue, 16 Jun 2009 11:26:04 -0700, Greg KH wrote:
> 
> > What kernel version are you seeing this problem on?  And what version is
> > this patch for?
> 
> I've seen it on 2.6.29.4-167.fc11.x86_64, patch is for git with head
> at 03347e2592078a90df818670fddf97a33eec70fb.

This should be resolved in Linus's tree now, can you try 2.6.31-rc1 when
it comes out and let me know if your patch is still needed or not?

thanks,

greg k-h
