Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYAYVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYAYVMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYAYVMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:12:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYAYVMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:12:00 -0500
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
From: Jon Masters <jcm@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com>
	 <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Fri, 25 Jan 2008 16:11:50 -0500
Message-Id: <1201295510.32422.69.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-25 at 10:44 -0800, Linus Torvalds wrote:

> and the problem seems to be that it does all these checks even for modules 
> that will never be loaded, because I use my own kernel, but with the 
> default Fedora initrd (which is trying to load modules for stuff that I 
> already have built in).

Thanks Linus. I'll pass this on to the mkinitrd maintainer. We'll try to
get this sorted out for you :)

Jon.


