Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXGDSVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXGDSVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 14:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXGDSVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 14:21:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59578 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140AbXGDSVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 14:21:40 -0400
Date: Wed, 4 Jul 2007 20:21:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: bo yang <bo.yang@lsi.com>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, sumant.patro@lsi.com
Subject: Re: [PATCH 1/4] scsi: megaraid_sas -- add hibernation support
Message-ID: <20070704182136.GA2731@elf.ucw.cz>
References: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The megaraid_sas driver doesn't support the hibernation, the
> suspend/resume routine implemented to support the hibernation.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>

I'm glad to see first scsi driver to have hibernation support
:-). Appart for whitespace, patch looks ok to me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
