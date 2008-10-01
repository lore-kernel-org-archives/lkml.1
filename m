Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYJAWmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYJAWmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJAWm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:42:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYJAWm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:42:27 -0400
Message-ID: <48E3FBD2.5010007@zytor.com>
Date: Wed, 01 Oct 2008 15:38:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akataria@vmware.com,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <48E3BC47.60900@zytor.com> <48E3BD83.2090801@goop.org> <48E3BE65.2050909@zytor.com> <48E3C32B.3090701@goop.org> <20081001203803.GB634@sequoia.sous-sol.org>
In-Reply-To: <20081001203803.GB634@sequoia.sous-sol.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>> "What hypervisor is this?" isn't a very interesting question; if you're  
>> even asking it then it suggests that something has gone wrong.
> 
> It's essentially already happening.  Everyone wants to be a better
> hyperv than hyperv ;-)

That's a hy-perv?  ;)

	-hpa
