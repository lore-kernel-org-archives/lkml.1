Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYHGGcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYHGGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYHGGcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:32:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52021 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYHGGcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:32:00 -0400
Message-ID: <489A96D1.4040108@pobox.com>
Date: Thu, 07 Aug 2008 02:31:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net, dhowells@redhat.com
Subject: Re: [patch 03/04] 3c59x: handle pci_name() being const
References: <20080702200902.909349505@mini.kroah.org> <20080702202453.GC14024@kroah.com> <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de>
In-Reply-To: <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert wrote:
> On Wed, Jul 02, 2008 at 01:24:53PM -0700, Greg Kroah-Hartman wrote:
>> This changes vortex_prob1() to handle pci_name() now returning a
>> constant string.
>>
> I got the same patch from David Howells already,
> that one is acked and send to Jeff Garzik.

could you resend, I only have the patch in quoted email...


