Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYJETHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYJETHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYJETHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:07:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53638 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYJETHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OW4dpzJzKVuW9Kw6X556YmGEJ7F9jkaMLVQwvQzQvQ9Ozmqq1OPDP/049ElokMATNz
         ycC7JV9G59gt26U4ur34mkkYmoAqBiLrQQaPcBcgqe8zHltA+AwxDs4V+4YdzvCdJzx3
         /i9dB2m7Mc1brfSHgVz7+5Xg7CaSCRzllLmk0=
Date: Sun, 5 Oct 2008 15:06:59 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081005190658.GC3263@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <200810052059.49942.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810052059.49942.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > Hi,
> > 
> > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > 64 laptop that is normally runs with Fedora distribution kernel.
> > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > speed, fans are constantly on, everything seems sluggish.
> > 
> > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > somewhere in tty_init.
> 
> Is that an HP box, by chance?
> 

Yeah, HP nx6115.

-- 
Dmitry
