Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXCNWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXCNWm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbXCNWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:42:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:49417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbXCNWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:42:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] clean up mach_reboot_fixups
Date: Wed, 14 Mar 2007 23:42:13 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45F8761F.8010203@goop.org>
In-Reply-To: <45F8761F.8010203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703142342.13639.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 23:24, Jeremy Fitzhardinge wrote:
> The reboot_fixups stuff seems to be a bit of a mess, specifically the
> header is in linux/ when its a purely i386-specific piece of code.  I'm
> not sure why it has its config option; its only currently needed for
> "geode-gx1/cs5530a", so perhaps whatever config option controls that
> hardware should enable this?

Thanks. Looks good.

-Andi
