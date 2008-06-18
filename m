Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYFRUeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYFRUeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYFRUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:34:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYFRUeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:34:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] DRM support for new pm_ops hooks
Date: Wed, 18 Jun 2008 22:35:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>
References: <200806171506.58345.jbarnes@virtuousgeek.org>
In-Reply-To: <200806171506.58345.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182235.02102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 of June 2008, Jesse Barnes wrote:
> The PCI linux-next branch has support for the new PM ops hooks, so I thought I 
> should refresh the DRM support for suspend/resume based on the new stuff.
> 
> I think we can get away with having drivers provide just save/restore hooks 
> and let the core take care of the rest.  When we flesh out the 
> prepare/complete hooks we may need another driver callback, not sure yet.
> 
> How does it look?

Good (to me). :-)

Thanks,
Rafael
