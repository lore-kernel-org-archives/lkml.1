Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXLEWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXLEWrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLEWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:47:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbXLEWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:47:09 -0500
Date: Wed, 5 Dec 2007 14:47:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: npiggin@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] mm: remove nopage
Message-Id: <20071205144700.729a0c98.akpm@linux-foundation.org>
In-Reply-To: <20071205071628.547577000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071628.547577000@nick.local0.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Dec 2007 18:16:04 +1100
npiggin@suse.de wrote:

> Nothing in the tree uses nopage any more. Remove support for it in the
> core mm code and documentation (and a few stray references to it in comments).

I'll duck this for now.  It's going to take a long time to get all those
other patches merged given my usual ~75% dropped-on-the-floor rate from
subsystem maintainers.  Please resend when mainline is nopage-free.


