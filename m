Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbXK2UuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbXK2UuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXK2Uts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:49:48 -0500
Received: from eazy.amigager.de ([213.239.192.238]:51116 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762088AbXK2Uts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:49:48 -0500
Date: Thu, 29 Nov 2007 21:49:43 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: XFS related Oops (suspend/resume related)
Message-ID: <20071129204943.GA1960@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20071112064706.GA23595@dose.home.local> <20071127211155.GK119954183@sgi.com> <200711272253.01136.rjw@sisk.pl> <200711292205.25431.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711292205.25431.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 22:05:24 +0100, Rafael J. Wysocki wrote:

[...]

> Tino, can you check if this patch helps, please?

Not really. I suspend one to several times a day, and in most cases
resume works. I thing checking the patch is hard when I have no real
procedure to reproduce the resume failure.

Regards,
Tino
