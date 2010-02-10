Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0BJJJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:09:36 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48046 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0BJJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:09:34 -0500
Date: Wed, 10 Feb 2010 11:09:27 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anatolij Gustschin <agust@denx.de>,
       Valentin Sitdikov <valentin.sitdikov@siemens.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Valentin Sitdikov <v.sitdikov@gmail.com>
Subject: Re: [PATCH] obsolete config in kernel source (LWMON5)
Message-ID: <20100210090927.GB14134@shisha.kicks-ass.net>
References: <20100205134256.GB7077@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205134256.GB7077@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 02:42:57 +0100, Christoph Egger wrote:
> Hi all!

Hi,

(adding Valentin's actual address to the loop)

> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	LWMON5 is a larger chunk from the kategory unreachable and
> here for ever. Seems this board was either only available from
> external trees or has been removed a long time ago. If you agree it
> might be worth removing it.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
> 
> Regards
> 
> 	Christoph Egger
> 
> [0] http://vamos1.informatik.uni-erlangen.de/
> 
> ----
> From 8334822cc79b4cf0b7f6844ebd952ebb24ee046f Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:49:13 +0100
> Subject: [PATCH] Remove conditionalizing on LWMON5
> 
> There was some condigionalizing for the LWMON5 boards in kernel
> source. However infrastructure for enabling this isn't here so
> probably the special case code can go as well.
> 
> Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

Acked-by: Alexander Shishkin <virtuoso@slind.org>

Regards,
--
Alex
