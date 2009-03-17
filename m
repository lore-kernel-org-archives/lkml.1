Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZCQWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZCQWxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZCQWwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:52:36 -0400
Received: from ns.suse.de ([195.135.220.2]:37383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbZCQWwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:52:36 -0400
Date: Tue, 17 Mar 2009 13:53:00 -0700
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: jkosina@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at
	kernel/workqueue.c:371
Message-ID: <20090317205300.GA4372@suse.de>
References: <6648.1237271589@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6648.1237271589@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 02:33:09AM -0400, Valdis.Kletnieks@vt.edu wrote:
> Yes, there's an NVidia driver loaded

Can you reproduce it without the nvidia driver loaded?

thanks,

greg k-h
