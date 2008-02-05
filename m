Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYBESho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYBESho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYBESh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:37:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbYBESh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:37:27 -0500
Date: Tue, 5 Feb 2008 10:37:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: aic7xxx build failure
Message-ID: <20080205103700.63b658f2@laptopd505.fenrus.org>
In-Reply-To: <1202236256.3133.52.camel@localhost.localdomain>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
	<1202235484.3133.49.camel@localhost.localdomain>
	<20080205182441.GF505@cs181133002.pp.htv.fi>
	<1202236256.3133.52.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 12:30:56 -0600

> > make: *** [sub-make] Error 2
> 
> Do I assume from this that you have different source and object
> directories?  There shouldn't be a failure if this is building
> in /home/bunk/linux/kernel-2.6/git/linux-2.6/ because the source file
> should be there.
> 
> James

time to run a fsck as well just to rule stuff out?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
