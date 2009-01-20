Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZATN52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZATN52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZATN5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:57:18 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43858 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZATN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:57:17 -0500
X-Auth-Info: m79rtkQcrUKUYnwZ9wM8HUkEiZf5n8d8b+fadQWwzcU=
Message-ID: <4975D838.5080703@denx.de>
Date: Tue, 20 Jan 2009 14:57:12 +0100
From: Anatolij Gustschin <agust@denx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Matteo Fortini <m.fortini@selcomgroup.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] mb862xx: Restrict compliation of platform driver to PPC
References: <496A89A1.8050302@gmail.com>
In-Reply-To: <496A89A1.8050302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Calaby wrote:
> mb862xx: Restrict compliation of platform driver to PPC
> 
> The OpenFirmware part of this driver is uncompilable on SPARC due to it's dependance on several PPC specific functions.
> 
> Restricting this to PPC to prevent these build errors.
> 
> This was found using randconfig builds.
> 
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

Acked-by: Anatolij Gustschin <agust@denx.de>

