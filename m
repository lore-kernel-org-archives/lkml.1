Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYD2NPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYD2NPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYD2NPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:15:35 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:30149 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYD2NPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:15:34 -0400
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, chrisw@redhat.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org, gcosta@redhat.com, avi@qumranet.com,
       virtualization@lists.linux-foundation.org, BENAMI@il.ibm.com
Subject: Re: PV DMA for PCI passthrough devices for KVM
From: Andi Kleen <andi@firstfloor.org>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
Date: Tue, 29 Apr 2008 15:15:24 +0200
In-Reply-To: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> (Amit Shah's message of "Tue, 29 Apr 2008 13:37:28 +0300")
Message-ID: <87skx4hker.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 13:08:31.0632 (UTC) FILETIME=[1F8D2100:01C8A9FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@qumranet.com> writes:

> This patchset implements PVDMA for handling DMA requests from
> devices assigned to the guest from the host machine.

You forgot to post a high level design overview of how this works,
what it is good for, what are the design trade offs etc.? 

Include that in the first patch.

-Andi

