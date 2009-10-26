Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZJ0AAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZJ0AAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZJ0AAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:00:10 -0400
Received: from kroah.org ([198.145.64.141]:48091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbZJZX75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:59:57 -0400
Date: Mon, 26 Oct 2009 16:43:32 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091026234332.GB26583@kroah.com>
References: <20091022091333.GA31023@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022091333.GA31023@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 11:13:34AM +0200, Pavel Machek wrote:
> 
> This adds generic_gpio and pmem support, both are needed for other
> dream drivers.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

I'd prefer to get the existing code building, before adding new stuff :(

thanks,

greg k-h
