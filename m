Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbXLJTy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbXLJTy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXLJTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:54:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:13556 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLJTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:54:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WhvtkDT+MY0PTqhSeymkRqBkSEyxgufWsbI6xiZIpod2RShH5akzoA/eF4ZaXdYUrTRPvifnZu0P6euMRVk72VYKsLag5/STFY/aVBiCgALWCS33g6T3X3FLYDk6GyZdxxn42q/HUO05FIxLGiTeVmXCALQsC0vBzTSry3ISQ9M=
Message-ID: <84144f020712101154u26b2d594jab199ea8804ed3bc@mail.gmail.com>
Date: Mon, 10 Dec 2007 21:54:17 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/net/ipg: Remove local definition of TRUE/FALSE
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       romieu@fr.zoreil.com
In-Reply-To: <20071210193139.16433.95480.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071210193139.16433.95480.sendpatchset@thinktank.campus.ltu.se>
X-Google-Sender-Auth: 6c02ac66087b1be1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Dec 10, 2007 9:29 PM, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Remove local definition of TRUE/FALSE.

This is already fixed in Francois' tree:

http://git.kernel.org/?p=linux/kernel/git/romieu/netdev-2.6.git;a=commitdiff;h=2af61e99e3d1c959840ea007ff56b15db794fb99

                               Pekka
