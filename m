Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYCNVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYCNVea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbYCNVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:34:05 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38825 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759248AbYCNVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:34:04 -0400
Date: Fri, 14 Mar 2008 17:34:03 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080314213403.GF1289@csclub.uwaterloo.ca>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz> <Pine.LNX.4.64.0803141020380.30831@jikos.suse.cz> <20080314182407.GA6990@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314182407.GA6990@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 07:24:08PM +0100, Pavel Machek wrote:
> Maybe. (Could we get host controller to effectively timestamp usb
> packets for us?)
> 
> ..but that is not a problem here, because X are broken even on ps/2
> keyboards. USB keyboards may be misdesigned, but they are not responsible
> for problems we see.

I don't own any USB keyboards (yet).  My problems are on PS/2 only.

--
Len Sorensen
