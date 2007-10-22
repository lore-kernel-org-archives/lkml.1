Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbXJVTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbXJVTNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXJVTMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:12:45 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39678 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbXJVTMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:12:44 -0400
Date: Mon, 22 Oct 2007 21:12:23 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: char/cyclades.c: inconsequent NULL checking
In-Reply-To: <471CF4AC.6060603@gmail.com>
Message-ID: <Pine.LNX.4.64.0710222112070.18815@twin.jikos.cz>
References: <20071022024734.GI30533@stusta.de> <471CF4AC.6060603@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Jiri Slaby wrote:

> > The Coverity checker spotted the following inconsequent NULL checking in 
> Where can one obtain such a checker?

That's a commercial proprietary thingie.

http://www.coverity.com/

-- 
Jiri Kosina
