Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZG3UTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZG3UTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZG3UTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:19:40 -0400
Received: from lazybastard.de ([212.112.238.170]:39054 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZG3UTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:19:40 -0400
Date: Thu, 30 Jul 2009 22:19:31 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Julia Lawall <julia@diku.dk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: Add kmalloc NULL tests
Message-ID: <20090730201931.GA12965@logfs.org>
References: <Pine.LNX.4.64.0907301608350.8734@ask.diku.dk> <20090730153658.GA22986@cmpxchg.org> <20090730183558.GA11763@logfs.org> <20090730191213.GA9471@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090730191213.GA9471@cmpxchg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 July 2009 21:12:14 +0200, Johannes Weiner wrote:
> 
> You will probably have a hard time establishing a userspace mapping
> before slab is initializied :)

Agreed.

Jörn

-- 
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams
