Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYJASL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYJASL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYJASLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:11:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYJASLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:11:18 -0400
Message-ID: <48E3BC47.60900@zytor.com>
Date: Wed, 01 Oct 2008 11:07:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akataria@vmware.com, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>
In-Reply-To: <48E3BBC1.2050607@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> No, we're not getting anywhere.  This is an outright broken idea.  The 
> space is too small to be able to chop up in this way, and the number of 
> vendors too large to be able to do it without having a central oversight.
> 

I suspect we can get a larger number space if we ask Intel & AMD.  In 
fact, I think we should request that the entire 0x40xxxxxx numberspace 
is assigned to virtualization *anyway*.

	-hpa
