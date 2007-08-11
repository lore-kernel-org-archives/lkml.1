Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXHKNlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXHKNlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 09:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXHKNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 09:40:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:36305 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752207AbXHKNkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 09:40:51 -0400
Date: Sat, 11 Aug 2007 15:42:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0708100931q3fad7f45la3e4046fa650482f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708111540520.11054@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com> 
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz> 
 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com> 
 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz> 
 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com> 
 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
 <d9b9d95f0708100931q3fad7f45la3e4046fa650482f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Renato Golin wrote:

> I've never tried force-feedback with it (or it never worked) as I don't 
> know which games support it (I thought none did).

You can use fftest utility (part of input-utils) which can be used to test 
FF capabilities of the device.

> I'll apply the patch and let you know.

Thanks,

-- 
Jiri Kosina
SUSE Labs
