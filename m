Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZJFNqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZJFNqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZJFNqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:46:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:26044 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbZJFNqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:46:02 -0400
Date: Tue, 6 Oct 2009 16:42:09 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006134209.GA4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091006094845.GT4452@nokia.com>
 <20091006114528.GV4452@nokia.com>
 <20091006131230.5301f711@lxorguk.ukuu.org.uk>
 <20091006130150.GY4452@nokia.com>
 <20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
 <20091006132752.GZ4452@nokia.com>
 <20091006144012.1af5744a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006144012.1af5744a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 13:43:58.0167 (UTC) FILETIME=[0DEF5E70:01CA468B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:40:12PM +0200, ext Alan Cox wrote:
> > unfortunately it didn't work. Although now I don't the debugging prints
> > complaining we've lost bytes, the transfer does get stuck in lot earlier
> > stage.
> > 
> > Maybe this is one fix but there's still other problem with that code ?
> 
> Or with completely unrelated code. I guess you need to measure what goes
> into receive_buf versus what appears in userspace

will do it soonish. Thanks Alan, I'll return to you when I have more
debugging.

-- 
balbi
