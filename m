Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbYJMMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbYJMMKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbYJMMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:10:23 -0400
Received: from lazybastard.de ([212.112.238.170]:33957 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbYJMMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:10:22 -0400
Date: Mon, 13 Oct 2008 14:10:10 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081013121009.GA22447@logfs.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081011143552.GA1556@ucw.cz> <20081012130103.GA14119@logfs.org> <20081013105700.GD1729@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013105700.GD1729@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 October 2008 12:57:00 +0200, Pavel Machek wrote:
> > On Sat, 11 October 2008 16:35:52 +0200, Pavel Machek wrote:
> > > 
> > > I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> > > if you write data 'nearby' root directory and power fails, bye bye
> > > filesystem, and journal will not help.
> > 
> > No device I've ever seen is that stupid.
> 
> I have adata SD flash cards that loose data even normal use, no power
> fails needed.

I don't doubt that.  There is a lot of crap for sale.  But your
description above does not match any crap I have ever encountered or
heard about.  Nor would it explain why you "loose data even normal use,
no power fails needed." ;)

Jörn

-- 
Schrödinger's cat is <BLINK>not</BLINK> dead.
-- Illiad
