Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0BBRut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:50:49 -0500
Received: from mail.perches.com ([173.55.12.10]:1811 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0BBRup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:50:45 -0500
Subject: Re: [PATCH V3] drivers/media/video/uvc: Use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B684361.2020009@infradead.org>
References: <1255471594.18975.79.camel@Joe-Laptop.home>
	 <20091013151652.5d2a49b7.akpm@linux-foundation.org>
	 <1255476919.18975.127.camel@Joe-Laptop.home>
	 <4B684361.2020009@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 09:50:43 -0800
Message-ID: <1265133043.1945.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:23 -0200, Mauro Carvalho Chehab wrote:
> I'm reviewing all patches marked as under review at Patchwork and I noticed
> that this one were never applied, nor I found any nack at linux-media ML.
> 
> What's the status for it?

Laurent wanted it withdrawn so he could fix some
backward compatibility thing he wanted.

http://lkml.org/lkml/2009/11/4/216

Nothing's happened since as far as I know.

