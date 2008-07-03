Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYGCMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYGCMDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYGCMCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:02:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbYGCMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:02:46 -0400
Message-ID: <486CA18A.2040604@firstfloor.org>
Date: Thu, 03 Jul 2008 11:53:14 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Removing sysdevs?
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com> <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com> <486BF9AC.6070704@firstfloor.org> <20080702221517.GA17929@kroah.com>
In-Reply-To: <20080702221517.GA17929@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The patches look fine, do you want me to take them through my tree, or
> do you want to have them go through somewhere else as you have some
> dependancies on them?

Through your tree is fine. Thanks.

Perhaps drop the x86 dynamic bank patch, it would actually conflict
with one patch currently in the x86 tree and doesn't really
belong into your tree.

> 
> If somewhere else, that's fine with me, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to them.

-Andi
