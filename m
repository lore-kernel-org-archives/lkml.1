Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZFAP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZFAP4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFAPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:55:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32985 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZFAPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:55:58 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm: intel: add ignore lvds quirk info for AOpen Mini PC
Date: Mon, 1 Jun 2009 11:54:41 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.3-140.fc11.x86_64; KDE/4.2.3; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net, xorg-devel@lists.x.org,
       linux-kernel@vger.kernel.org, Florian Demmer <florian@demmer.org>,
       eric@anholt.net
References: <200905271720.40776.jarod@redhat.com> <20090601120126.550b2d15@jbarnes-x200>
In-Reply-To: <20090601120126.550b2d15@jbarnes-x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011154.42177.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009 07:01:26 Jesse Barnes wrote:
> Patches to the i915 driver should generally go
> to intel-gfx@lists.freedesktop.org so we don't miss them.  Thanks.

Ah, sorry, didn't know that. Might I suggest adding a note to that
effect in MAINTAINERS? Reasonably sure that's where I looked to try
to figure out where to send a prior i915 patch and I don't see a
ref to that list in there now.

-- 
Jarod Wilson
jarod@redhat.com
