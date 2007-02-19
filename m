Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXBSNNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXBSNNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbXBSNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:13:47 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:35165 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbXBSNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:13:46 -0500
Date: Mon, 19 Feb 2007 14:14:08 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] override build timestamp
Message-ID: <20070219131408.GA4203@aepfle.de>
References: <20070216215213.GA10732@aepfle.de> <Pine.LNX.4.64.0702180259210.14458@scrub.home> <20070218081243.GA25618@aepfle.de> <Pine.LNX.4.64.0702181715570.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702181715570.14457@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, Roman Zippel wrote:

> This information could also be added to the version string like 
> CONFIG_LOCALVERSION_AUTO does. OTOH rather than abusing the build date 
> (which may not mean much, but it nevertheless has a meaning), I'd rather 
> add the possibility to add extra information.

What exactly do you have in mind, how to provide the extra info?
