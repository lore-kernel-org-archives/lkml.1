Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXERUE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXERUE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXERUEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:04:49 -0400
Received: from waste.org ([66.93.16.53]:50114 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXERUEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:04:48 -0400
Date: Fri, 18 May 2007 15:04:27 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
Message-ID: <20070518200426.GB11166@waste.org>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
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

This could stand some compression.

> +   All Rights Reserved.

All rights are not reserved, otherwise it wouldn't be GPL.

-- 
Mathematics is the supreme nostalgia of our time.
