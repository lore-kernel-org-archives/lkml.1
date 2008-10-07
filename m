Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYJGO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYJGO5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYJGO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:57:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYJGO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:57:39 -0400
Date: Tue, 7 Oct 2008 07:56:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB fixes
In-Reply-To: <200810070659.01415.hverkuil@xs4all.nl>
Message-ID: <alpine.LFD.2.00.0810070756030.3208@nehalem.linux-foundation.org>
References: <20081005002701.31a2ee5f@pedra.chehab.org> <200810070659.01415.hverkuil@xs4all.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Oct 2008, Hans Verkuil wrote:
>
> It was a patch for 2.6.28 where the BKL was pushed down from v4l core to 
> the drivers, not for 2.6.27!

Heh. Reverted,

		Linus
