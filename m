Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXEXXGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXEXXGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXEXXGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:06:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXEXXGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:06:43 -0400
Date: Thu, 24 May 2007 19:06:34 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524230634.GA30651@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>,
	Len Brown <len.brown@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org> <46560E4F.2080009@zytor.com> <20070524224154.GA29337@redhat.com> <465616F3.6090501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465616F3.6090501@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:51:31PM -0700, H. Peter Anvin wrote:
 > What you're describing is correct for later-level AMD/Cyrix chips,
 > however, when 3DNow! was first introduced they foolishly squatted on the
 > Intel-assigned CPUID flags.

Hmm, the 3dnow spec (doc 21928e) has it in the right place, and I don't see
anything in the errata docs I have.

Do you have more info on this?  If its true, I'd like to make x86info
aware of it.

	Dave

-- 
http://www.codemonkey.org.uk
