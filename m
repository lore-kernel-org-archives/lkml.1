Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYJAUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYJAUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYJAUjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:39:25 -0400
Received: from sous-sol.org ([216.99.217.87]:33163 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752332AbYJAUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:39:24 -0400
Date: Wed, 1 Oct 2008 13:38:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akataria@vmware.com,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and
	Linux.
Message-ID: <20081001203803.GB634@sequoia.sous-sol.org>
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <48E3BC47.60900@zytor.com> <48E3BD83.2090801@goop.org> <48E3BE65.2050909@zytor.com> <48E3C32B.3090701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3C32B.3090701@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> "What hypervisor is this?" isn't a very interesting question; if you're  
> even asking it then it suggests that something has gone wrong.

It's essentially already happening.  Everyone wants to be a better
hyperv than hyperv ;-)
