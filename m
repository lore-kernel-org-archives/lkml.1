Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZEUOEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZEUOEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZEUODG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:03:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:52089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbZEUODF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:03:05 -0400
Date: Thu, 21 May 2009 06:55:51 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: data.c should include delay.h
Message-ID: <20090521135551.GB29375@suse.de>
References: <1242219648-16165-1-git-send-email-a.beregalov@gmail.com> <1242219648-16165-2-git-send-email-a.beregalov@gmail.com> <20090513132342.GA16280@orion> <a4423d670905210608k25a92253j21fc231dd467bff2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670905210608k25a92253j21fc231dd467bff2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 05:08:28PM +0400, Alexander Beregalov wrote:
> 2009/5/13 Alexander Beregalov <a.beregalov@gmail.com>:
> > Fix this build error:
> > .../data.c:86: error: implicit declaration of function 'udelay'
> >
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > ---
> 
> Greg,
> Please apply instead my another patch, which includes delay.h in comedidev.h.

Ok, will do.

thanks,

greg k-h
