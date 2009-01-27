Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZA0NSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZA0NSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZA0NS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:18:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:37068 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbZA0NSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:18:25 -0500
Date: Tue, 27 Jan 2009 14:18:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
In-Reply-To: <1232969733.20525.4.camel@johannes.local>
Message-ID: <alpine.LNX.1.10.0901271417070.5377@jikos.suse.cz>
References: <1232635779.4224.12.camel@johannes.local>  <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>  <1232968513.20525.1.camel@johannes.local>  <alpine.LNX.1.10.0901261220150.5377@jikos.suse.cz> <1232969733.20525.4.camel@johannes.local>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Johannes Berg wrote:

> Is it possible that I was just in an environment where there was lots of 
> random infrared traffic that the device picked up? Is it possible to 
> disable it completely?

Well, you can always unbind the driver from the device, I guess that 
should shut it up.

But I'd like to understand why this started happening all of a sudden. Are 
you able to reproduce this easily?

-- 
Jiri Kosina
SUSE Labs
