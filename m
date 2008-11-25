Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYKYQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYKYQDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYKYQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:03:08 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1808 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYKYQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:03:07 -0500
Date: Tue, 25 Nov 2008 17:02:46 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Nir Tzachar <nir.tzachar@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de
Subject: Re: [PATCH] ncurses based config V2
In-Reply-To: <9b2db90b0811250004k5494cff7sfb22a91e0f6f6ab@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811251655230.13549@localhost.localdomain>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> 
 <1220603220-17090-1-git-send-email-nir@tzachar.com>  <20080905195930.GA27913@1wt.eu>
  <20081124184428.GA17085@uranus.ravnborg.org> 
 <Pine.LNX.4.64.0811250333060.13549@localhost.localdomain>
 <9b2db90b0811250004k5494cff7sfb22a91e0f6f6ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 25 Nov 2008, Nir Tzachar wrote:

> > Before we keep discussing the colors, I'd rather suggest to drop them
> > completely and maybe use colors for what actually needs attention.
> 
> The idea is using colors to give it a more modern look. Dropping
> colors will bring us back to the "dark ages"...

After that came the "child ages", where every available color was used 
because it was there. :-)
For modern interfaces less is more, so if color is used, it should have a 
purpose.

bye, Roman
