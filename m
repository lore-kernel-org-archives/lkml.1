Return-Path: <linux-kernel-owner+w=401wt.eu-S1765246AbYBMFVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765246AbYBMFVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYBMFVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:21:44 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:38885 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYBMFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:21:44 -0500
Date: Tue, 12 Feb 2008 21:21:43 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
In-Reply-To: <20080212190235.4e86baf8@gaivota>
Message-ID: <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Mauro Carvalho Chehab wrote:
>    - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;

So you decided to just commit this one with the race condition anyway?
