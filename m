Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYAUSoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYAUSoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYAUSoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:44:07 -0500
Received: from waste.org ([66.93.16.53]:43226 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYAUSoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:44:07 -0500
Subject: Re: [PATCH] random - add async I/O support
From: Matt Mackall <mpm@selenic.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: tytso@mit.edu, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080121181841.GA7383@c2.user-mode-linux.org>
References: <20080121181841.GA7383@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 12:43:25 -0600
Message-Id: <1200941005.13649.45.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 13:18 -0500, Jeff Dike wrote:
> Add async notification support to /dev/random.

This conflicts just about everywhere with my latest code, but I'll fix
that up.

-- 
Mathematics is the supreme nostalgia of our time.

