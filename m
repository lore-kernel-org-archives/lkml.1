Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZLUHgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZLUHgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZLUHgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:36:16 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:64791 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZLUHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mtFdE7fyPJzCHncDlBvyEDYldpeYERiZve6Q1ntHI1YhDVShbdKy0UVaZq1CzJso9f
         ApfxfiLUV3WXv29Y2P375TIl8l6GmZoluZVRe6UskTLdJhQQMv7Vn93ekc5GqRYXtVOY
         O80aggSoPfuLUkp+BMqrlPlaPDtjbzHfyJLIE=
Date: Sun, 20 Dec 2009 23:35:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
Message-ID: <20091221073555.GB3234@core.coreip.homeip.net>
References: <200912210140.19713.rjw@sisk.pl> <4B2F22EF.6040500@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F22EF.6040500@crca.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nigel,

On Mon, Dec 21, 2009 at 06:25:35PM +1100, Nigel Cunningham wrote:
> Hi.
> 
> Rafael J. Wysocki wrote:
> > I'm not sure what the next step should be at this point.  To me, the picture is
> > quite clear now, but perhaps we ought to run more tests on some other machines
> > or something.  Please let me know what you think.
> 
> Looks great. If you do decide you want other machines tested, I'll
> happily try the machines around here:
> 
> - Dell M1530
> - Omnibook XE3-GF.
> - Via LN10000 based Mythtv Box
> - Desktop machine - Some Intel-based mobo I've forgotten the name of.
> 

Would you mind also testing patch that I just posted that changes full
PS/2 keyboard and mouse resets to more lightweight versions?

Thanks!

-- 
Dmitry
