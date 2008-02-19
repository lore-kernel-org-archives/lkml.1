Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYBSNMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYBSNMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBSNMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:12:48 -0500
Received: from eazy.amigager.de ([213.239.192.238]:37951 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYBSNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:12:47 -0500
Date: Tue, 19 Feb 2008 14:12:42 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2 regression - hang on suspend
Message-ID: <20080219131242.GA22571@dose.home.local>
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1203422386.10992.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203422386.10992.2.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:59:46 +0100, Soeren Sonnenburg wrote:
> Hi,
> 
> since 2.6.25-rc1 (first version I tried) and still in rc2 (and git), I
> see a hang on s2ram already when trying to suspend.
> 
> This is on a macbookpro 1,1  - which steps should I do next to help
> isolating the problem?

Could this be the same as http://lkml.org/lkml/2008/2/17/381?

Regards,
Tino
