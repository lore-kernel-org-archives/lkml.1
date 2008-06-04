Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYFDBOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYFDBOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFDBON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:14:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:64194 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYFDBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zgjow4ZrH3ubU+uQs0hjcKsH3FFlgeFT+/Y7jrFxDBywBfmOZggxDEtWMVqxqO8fjHPyHsd0lEXnybMWu73Q1MbpsEEevfQDAKLTV2Mxwu2fjOeaQGXAWl1U9AF6Ku2p9AdFyVk7mxnWAVvFa/lsHQszlzHGbQ2jwfafyq22SRQ=
Message-ID: <6934efce0806031814s6c416261pa9285aee9ae547a9@mail.gmail.com>
Date: Tue, 3 Jun 2008 18:14:12 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: david@lang.hm
Subject: Re: Future Linux on Bistable Storage
Cc: "Rick van Rein" <rick@groengemak.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0806020953420.28080@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080602125904.GA15129@phantom.vanrein.org>
	 <alpine.DEB.1.10.0806020953420.28080@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the alternate technologies that I have heard about are either _far_ less
> dense then DRAM (similar to static ram) or require erasing in blocks
> (similar to flash).

I will agree with this.

> niether one is appropriate for a large, flat addressed
> memory architecture as you list below.

I don't agree with this one.   Erase blocks don't automatically
disqualify a memory as a fit into a flat addressed arch.   You need to
play games at the memory management layer to make it work, but it's
not impossible.
