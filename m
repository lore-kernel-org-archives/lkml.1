Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZINXew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZINXew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZINXev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:34:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbZINXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:34:51 -0400
Message-ID: <4AAED1E2.7060906@zytor.com>
Date: Mon, 14 Sep 2009 16:29:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com> <20090911211654.GA11399@c2.user-mode-linux.org>
In-Reply-To: <20090911211654.GA11399@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 02:16 PM, Jeff Dike wrote:
> 
> I figured out how to make this work - see below.
> 
> 			Jeff
> 

Jeff, could you re-send this as a proper patch with an SOB line?

	-hpa
