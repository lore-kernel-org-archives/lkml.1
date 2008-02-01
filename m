Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYBAQnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYBAQnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYBAQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:43:25 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:53843 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbYBAQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:43:24 -0500
Date: Fri, 1 Feb 2008 17:43:21 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080201164321.GA8551@dis.manty.net>
References: <20080125211153.GA10203@dis.manty.net> <20080128233334.GA14326@dis.manty.net> <20080131215541.GA22018@dis.manty.net> <20080131213711.GM8953@1wt.eu> <20080201000442.GA26357@dis.manty.net> <20080201053305.GK27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201053305.GK27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See if the patch below takes care of all of that:

Yes, the patch seems to fix the problem, I have applied it over 2.6.24 and
now the machine is at 1000FD working ok.

Thanks for the fix.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
