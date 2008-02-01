Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbYBAAFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbYBAAFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbYBAAEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:04:50 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:54114 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbYBAAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:04:48 -0500
Date: Fri, 1 Feb 2008 01:04:42 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080201000442.GA26357@dis.manty.net>
References: <20080125211153.GA10203@dis.manty.net> <20080128233334.GA14326@dis.manty.net> <20080131215541.GA22018@dis.manty.net> <20080131213711.GM8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131213711.GM8953@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have today compiled dl2k from git, the version with the 2007-12-23 patches
> from Al Viro: dl2k endianness fixes (.24 fodder?) Right before the Al Viro
> patches. This seems to be working perfectly on my system.

Ok, I've been applying Al's patches one by one, everything went fine till I
applied the "dl2k: MSCR, MSSR, ESR, PHY_SCR fixes" patch. With this patch I
experimented the behaviour I commented on my first message.

I don't know what else to try now, any ideas?

Regards...
-- 
Manty/BestiaTester -> http://manty.net
