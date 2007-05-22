Return-Path: <linux-kernel-owner+w=401wt.eu-S935350AbXEVTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935350AbXEVTlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbXEVTlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:41:42 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37868 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357AbXEVTll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:41:41 -0400
Date: Tue, 22 May 2007 21:40:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nitin Gupta <nitingupta910@gmail.com>
cc: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705222139550.4452@yvahk01.tjqt.qr>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 15:28, Nitin Gupta wrote:
> +/* lzo1x.h -- public interface of the LZO1X compression algorithm
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
> +   All Rights Reserved.

Oh holy, this is almost as bad as a 4-clause BSD-style license.
(Could the author just write "1996-2005" instead, like most
GNU tools do?)


	Jan
-- 
