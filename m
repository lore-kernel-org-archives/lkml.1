Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZLKOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZLKOmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbZLKOmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:42:16 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:36732 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZLKOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:42:15 -0500
Date: Fri, 11 Dec 2009 08:42:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ioannis Kyriakopoulos <johnkyr83@hotmail.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: Finding and chaniging registered clocksources
In-Reply-To: <SNT111-DS18FDA82A2FB992AC38B693A78C0@phx.gbl>
Message-ID: <alpine.DEB.2.00.0912110841340.32415@router.home>
References: <SNT111-DS372EC73016B4FB39E0ACAA78C0@phx.gbl> <alpine.DEB.2.00.0912110802250.32415@router.home> <SNT111-DS18FDA82A2FB992AC38B693A78C0@phx.gbl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, Ioannis Kyriakopoulos wrote:

> cat: can't open
> '/sys/devices/system/clocksource/clocksource0/current_clocksource': No such
> file or directory
> In general, my /sys directory is empty. This file should exist to my
> filesystem prior to kernel execution or should it be created by the kernel
> when it starts executing; but for some reason it is not being created in my
> case?

mount -t sys none /sys

