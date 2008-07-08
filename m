Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYGHHrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYGHHrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYGHHr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:47:26 -0400
Received: from eazy.amigager.de ([213.239.192.238]:33370 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGHHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:47:25 -0400
Date: Tue, 8 Jul 2008 09:48:18 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Keeping track of spin-down/spin-up and causes of spin-up?
Message-ID: <20080708074818.GA341@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <jwvskuku9jr.fsf-monnier+gmane.linux.kernel@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jwvskuku9jr.fsf-monnier+gmane.linux.kernel@gnu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 03:25:18 -0400, Stefan Monnier wrote:
> I clearly remember seeing a reference to some system that allowed to
> keep track of causes of disk spin-up, but Google seems to say
> I'm deluded.  [ Or maybe my memory confused it for the facility used by
> powertop to keep track of causes of CPU wake-ups? ]
> 
> In any case, I have a machine here whose disk keeps spinning back up
> on a regular basis, and I can't seem to find any correlated event.
> Is there a tool that can help me track down the reason why the disk
> is accessed?

See Documentation/laptops/laptop-mode.txt, the notes regarding
block_dump.

Regards,
Tino
