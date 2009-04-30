Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbZD3VzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbZD3VzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbZD3Vys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:54:48 -0400
Received: from 1wt.eu ([62.212.114.60]:4196 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762875AbZD3Vyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:54:47 -0400
Date: Thu, 30 Apr 2009 23:54:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/88] 2.6.28.10-stable review
Message-ID: <20090430215433.GG570@1wt.eu>
References: <20090430170122.GA16015@kroah.com> <20090430214450.GC7174@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430214450.GC7174@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 06:44:50PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 30 Apr 2009, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.28.10 release.
> > 
> > NOTE!  This is going to be the last release in the 2.6.28-stable series!
> 
> Could you be convinced to keep 2.6.28-stable around for a little longer?
> 
> 2.6.29 is still much too young, as one can see from the size of 2.6.29.2,
> and the fact that the queue for 2.6.29 isn't even empty yet and there are
> already more patches waiting to get queued...

Why not stay on 2.6.27 if you need longer support ? I you really need some
2.6.28-specific features, it should not be *that* hard to incrementally
apply next 2.6.27.X patchsets to your latest 2.6.28.Y, and this will leave
you with some time to see 2.6.29 getting ready for your usage.

Just my 2 cents,
Willy

