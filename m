Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZADJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZADJ72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZADJ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:59:20 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27759 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZADJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:59:20 -0500
Date: Sun, 4 Jan 2009 10:59:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Huang Weiyi <weiyi.huang@gmail.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove duplicated #include
In-Reply-To: <20090104110951.C9AB.WEIYI.HUANG@gmail.com>
Message-ID: <alpine.LNX.2.00.0901041057400.26359@swampdragon.chaosbits.net>
References: <20090104110951.C9AB.WEIYI.HUANG@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Huang Weiyi wrote:

> Removed duplicated #include in lib/swiotlb.c.
> 

This is identical to a patch I already submitted - 
http://lkml.org/lkml/2009/1/2/360 - but I don't know if that one has been 
merged anywhere yet.

-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

