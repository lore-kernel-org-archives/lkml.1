Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYBAQgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYBAQgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbYBAQgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:36:23 -0500
Received: from gw.goop.org ([64.81.55.164]:44185 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbYBAQgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:36:23 -0500
Message-ID: <47A34A61.80000@goop.org>
Date: Fri, 01 Feb 2008 08:35:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 0 of 4] x86: cleanups from pmd lifetime series
References: <patchbomb.1201564120@localhost> <20080201162656.GE15156@elte.hu>
In-Reply-To: <20080201162656.GE15156@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> FYI, only this one applied to the latest x86.git tree, could you please 
> resend? I guess the pgalloc.h related revert interfered.
>   

OK.  I'll do a quick rebase to this morning's tree and resend.

    J
