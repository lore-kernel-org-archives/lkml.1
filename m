Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbXFOR3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbXFOR3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXFOR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:28:55 -0400
Received: from outbound-mail-48.bluehost.com ([69.89.18.17]:39985 "HELO
	outbound-mail-48.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312AbXFOR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:28:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Fri, 15 Jun 2007 10:28:41 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <200706071530.51552.jesse.barnes@intel.com> <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan> <46726727.5090003@macroscoop.nl>
In-Reply-To: <46726727.5090003@macroscoop.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706151028.41773.jbarnes@virtuousgeek.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 15, 2007 3:17:11 Pim Zandbergen wrote:
> Not that it matters much, as the current i810/intel xorg driver does
> not yet support the GMA3100, so I'm using the vesa driver.

I *think* the latest trees support that chip.  If you're feeling brave, 
checkout the latest version of the xf86-video-intel driver from 
freedesktop.org and give it a try (to get 3d you'll also need newer DRM 
and AGP bits).

Jesse
