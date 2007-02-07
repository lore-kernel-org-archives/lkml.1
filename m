Return-Path: <linux-kernel-owner+w=401wt.eu-S1161191AbXBGLCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161191AbXBGLCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161190AbXBGLCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:02:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:50761 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161180AbXBGLCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:02:32 -0500
Date: Wed, 7 Feb 2007 12:05:19 +0100
From: Jan Kara <jack@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Message-ID: <20070207110519.GA5361@duck.suse.cz>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI> <20070207104549.GF24590@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0702071248260.25085@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071248260.25085@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-02-07 12:50:34, Pekka J Enberg wrote:
> Hi Honza,
> 
> On Wed, 7 Feb 2007, Jan Kara wrote:
> >   Have you considered using similar hack as bad_inode.c instead of
> > revoked_inode.c?
> 
> I am not sure what you mean, revoked_inode.c looks pretty much the same as 
> bad_inode.c in mainline...
  Oops, sorry for confusion. I was looking into 2.6.19 and there the code
looks differently. In 2.6.20, obviously your method was preferred.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
