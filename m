Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbZJIKyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbZJIKyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbZJIKyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:54:00 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:60295 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbZJIKyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:54:00 -0400
Date: Fri, 9 Oct 2009 12:53:21 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS: remove code that has been commented out for many
	years
Message-ID: <20091009105321.GD24141@axis.com>
References: <alpine.LSU.2.00.0910091156580.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910091156580.19284@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:58:17AM +0200, Jiri Kosina wrote:
> [ I have already queued this in trivial tree. If you have objections, 
>   please shout ]
> 
> Remove the dump_tlb_all() function that has been commented out for
> many years.

I have no objections, the code is obviously old debug.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
