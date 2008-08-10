Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYHKDJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYHKDJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYHKDIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:08:52 -0400
Received: from esbens.latnet.lv ([92.240.66.74]:39014 "EHLO esbens.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYHKDIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:08:51 -0400
From: Aivils Stoss <aivils@latnet.lv>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Date: Sun, 10 Aug 2008 04:08:37 +0100
User-Agent: KMail/1.9.7
Cc: linux-input@vger.kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
       linuxconsole-dev@lists.sourceforge.net
References: <200808080702.24969.aivils@latnet.lv> <20080809104226.GF4546@implementation>
In-Reply-To: <20080809104226.GF4546@implementation>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808100408.37473.aivils@latnet.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008 11:42:26 am Samuel Thibault wrote:
> Aivils Stoss, le Fri 08 Aug 2008 07:02:24 +0100, a écrit :
> > I suppose this is Linux kernel bug because i test keyboards under
> > Windows, which support any schema of cascading of usb hubs.
>
> On the very same machine and hubs?

Yes, on same machine. Under Windows i don't have evdev interface,
checked only how keypress go to console.
Of course to repeat a try You must have at least 5 keyboards and
1 7-port or 2 4-port hubs and kernel 2.6.22 and above. I allways
got result - 5th, 6th, 7th keyboard does not send events to console
or evdev.

>
> Samuel


