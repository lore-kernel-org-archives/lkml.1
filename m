Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZIOGTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZIOGTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZIOGTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:19:30 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:38684 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbZIOGT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GVfN2H6NRCtD9LvbhMBDf32qGF8aVniL0x3ADd+wHdoZFH0Fb4ow3SMBP1pJN7wp1u
         wKi8d8lEh3NKWVutShwsnXuuAAPl9J06xSotABF0jkLINRekBXVFXn4CUpeMdQf/lGFC
         E5+fQgNQCevJOWp8owoEnJ2vMGqw0EwPB26Rs=
Date: Mon, 14 Sep 2009 23:19:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Franz.Sirl-kernel@lauterbach.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] macintosh/hid: keycode-mapping for left click
Message-ID: <20090915061927.GA10232@core.coreip.homeip.net>
References: <80pr9tz2pb.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80pr9tz2pb.fsf@merkur.tec.linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Mon, Sep 14, 2009 at 10:33:20PM +0200, John Ogness wrote:
> Hi,
> 
> This patch adds support for mapping the left mouse button to a
> keycode. The driver already mapped the middle and right buttons.
> 
> Since the single mouse-button on my Apple laptop broke, I figured the
> driver might as well support all three buttons. Now I can keep using my
> laptop without problems.
> 

Thank you for the patch however I will not apply it. While kernel has a
lot of quirks to work around broken hardware those apply to the design
brokenness, not old-age brokenness.

-- 
Dmitry
