Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbYGPWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbYGPWJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYGPWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:09:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYGPWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:09:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Please pull ACPI updates
Date: Thu, 17 Jul 2008 00:11:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20080716214516.GA10777@basil.nowhere.org>
In-Reply-To: <20080716214516.GA10777@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807170011.12184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of July 2008, Andi Kleen wrote:
> 
> Linus,
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-merge-2.6 release-2.6.27
> 
> to get the initial ACPI updates for 2.6.27. We got a few more changes
> dependent on yet unpulled trees and some other candidate patches,
> but that's the bulk for the changes intended for 2.6.27. Most of that
> has been collected by Len Brown before he went on sabbatical. I was
> relatively conservative with additional changes so far.

Well, IMO it would be better to merge PCI first.

Thanks,
Rafael
