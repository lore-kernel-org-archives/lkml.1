Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZJBOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZJBOWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZJBOWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:22:44 -0400
Received: from kroah.org ([198.145.64.141]:35621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZJBOWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:22:44 -0400
Date: Fri, 2 Oct 2009 07:20:21 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/30] 2.6.30.9-stable review
Message-ID: <20091002142021.GB20816@kroah.com>
References: <20091001233504.GA17709@kroah.com>
 <20091002024317.GA2045@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002024317.GA2045@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 11:43:17PM -0300, Henrique de Moraes Holschuh wrote:
> Greg, I sent a few days ago to you guys a patch for thinkpad-acpi to unbreak
> a _very_ annoying brightness control bug on 2.6.30 on many IBM thinkpads.
> 
> Could you please include it?
> 
> http://patchwork.kernel.org/patch/50201/

Ick, you are right, I missed that one somehow, it's still in my
"todo-stable" mbox as well.  My fault, I'll go queue it up and release a
-rc2 for .30-stable.

thanks,

greg k-h
