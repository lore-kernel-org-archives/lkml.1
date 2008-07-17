Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYGQGrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYGQGrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYGQGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:47:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60805 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYGQGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:47:11 -0400
Message-ID: <487EEAEB.4050009@firstfloor.org>
Date: Thu, 17 Jul 2008 08:47:07 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org>
In-Reply-To: <200807161633.01375.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, July 16, 2008 3:11 pm Rafael J. Wysocki wrote:
>> On Wednesday, 16 of July 2008, Andi Kleen wrote:
>>> Linus,
>>>
>>> Please pull from
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-merge-2.6
>>> release-2.6.27
>>>
>>> to get the initial ACPI updates for 2.6.27. We got a few more changes
>>> dependent on yet unpulled trees and some other candidate patches,
>>> but that's the bulk for the changes intended for 2.6.27. Most of that
>>> has been collected by Len Brown before he went on sabbatical. I was
>>> relatively conservative with additional changes so far.
>> Well, IMO it would be better to merge PCI first.
> 
> Yeah, they're interdependent (I pulled from Len's tree, hopefully Andi 
> preserved the changesets).  I had wanted to do a little more testing of what 
> I've got, but I haven't heard any huge complaints so far so maybe things are 
> ok.  I'll generate a pull request now.

Hmm, but if you're dependent ACPI needs to go in first anyways, doesn't it?

I don't think the ACPI tree is dependent on PCI at least. Or at least I didn't
notice any problems in this area.

-Andi

