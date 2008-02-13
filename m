Return-Path: <linux-kernel-owner+w=401wt.eu-S1763817AbYBMWz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763817AbYBMWz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765444AbYBMWzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:55:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763820AbYBMWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:55:08 -0500
Date: Wed, 13 Feb 2008 14:54:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: harvey.harrison@gmail.com, torvalds@linux-foundation.org,
       davem@davemloft.net, tglx@linutronix.de, hpa@zytor.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
 symbols going away
Message-Id: <20080213145405.35fb5733.akpm@linux-foundation.org>
In-Reply-To: <20080213224308.GD12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick>
	<20080213223455.GB12383@cs181133002.pp.htv.fi>
	<20080213224308.GD12383@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 00:43:08 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> There's simply no point in treating the removal of exports differently
> from the many other API breaks we have in each release.

I have repeatedly and relatively patiently explained to you what the
point is.  Simply saying that there isn't one doesn't actually make
it go away.
