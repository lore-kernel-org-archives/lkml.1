Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZECV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZECV7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZECV7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:59:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59170 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZECV7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:59:39 -0400
Date: Sun, 3 May 2009 22:59:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Bank screen after resume on Dell XPS M1330
Message-ID: <20090503215935.GA27257@srcf.ucam.org>
References: <200905031111.50789.arvidjaar@mail.ru> <20090503105932.GA18170@srcf.ucam.org> <20090503215740.GG1368@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503215740.GG1368@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:57:41PM +0200, Pavel Machek wrote:
> On Sun 2009-05-03 11:59:32, Matthew Garrett wrote:
> > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov wrote:
> > > 01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M GS 
> > > (rev a1)
> > 
> > We don't know how to reinitialise nvidia graphics hardware.
> 
> s2ram tool and/or Xserver may be able to reinit the video....

Not for current nivida, except for some Thinkpads.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
