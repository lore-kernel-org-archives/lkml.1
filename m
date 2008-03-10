Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYCJCnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYCJCnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYCJCm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:42:58 -0400
Received: from saeurebad.de ([85.214.36.134]:44663 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYCJCm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:42:57 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare with jiffies
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	<20080309095802.70d91c7b@core>
	<a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
	<20080309110808.2249aa3a@core>
	<20080309120133.2d1363e4.akpm@linux-foundation.org>
	<a8e1da0803091903i3ea7a54bkea797a43eeae462e@mail.gmail.com>
Date: Mon, 10 Mar 2008 03:41:16 +0100
In-Reply-To: <a8e1da0803091903i3ea7a54bkea797a43eeae462e@mail.gmail.com> (Dave
	Young's message of "Mon, 10 Mar 2008 10:03:47 +0800")
Message-ID: <87ve3v8fn7.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

"Dave Young" <hidave.darkstar@gmail.com> writes:

> Hannes, It's more like your is_past/is_future but looks better when
> along with _eq

I agree.  And it's better to have `jiffies' in the names, anyway.

	Hannes
