Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZGNPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZGNPF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZGNPFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:05:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:52419 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZGNPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:05:25 -0400
Date: Tue, 14 Jul 2009 17:05:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: Input driver for Twinhan USB 6253:0100 remote
 control
In-Reply-To: <20090713141958.4d17f32a@neptune.home>
Message-ID: <alpine.LNX.2.00.0907141705060.813@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com> <49E4C9CF.5060504@rtr.ca> <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
 <49E5EAD7.7000309@rtr.ca> <alpine.LNX.2.00.0904161123180.13028@wotan.suse.de> <20090712182026.7a09c736@neptune.home> <alpine.LNX.2.00.0907131048110.10476@wotan.suse.de> <20090713113157.701ba027@neptune.home> <alpine.LNX.2.00.0907131316420.10476@wotan.suse.de>
 <20090713141958.4d17f32a@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-166026993-1247583923=:813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-166026993-1247583923=:813
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 13 Jul 2009, Bruno Prémont wrote:

> All dummy Ctrl, Alt, Meta, ... key press/release events generated
> by the remote are silenced by "unmapping" them. This makes Power and
> Volume keys single-key and strips the regular (even while idle) key
> release events for Ctrl, Alt, Meta, ...
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

Applied, thanks Bruno.

-- 
Jiri Kosina
SUSE Labs
--168427776-166026993-1247583923=:813--
