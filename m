Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYE1SHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYE1SHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYE1SHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:07:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYE1SHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:07:00 -0400
Date: Wed, 28 May 2008 13:59:41 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
Message-ID: <20080528175941.GA4642@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 07:48:03PM +0200, Jan Engelhardt wrote:
 > 
 > On Wednesday 2008-05-28 18:57, Dave Jones wrote:
 > 
 > >Trying to boot a 64-bit kernel on a 32bit Pentium 4 gets
 > >you an amusing message along the lines of.
 > >"you need an x86-64, but you only have an i1586"
 > >due to the P4 being family F.  Munge it to be 686.
 > 
 > What is wrong with it? If i386, 486, 586 and 686 are valid names,
 > why should not 786 (or rather 1586... since someone thought it
 > would be cool to jump the number^1) be?

When you find the Intel literature that refers to the '786' or the '1586',
feel free to send a patch. In the meantime, we'll refer to it as
the rest of the world does.

	Dave

-- 
http://www.codemonkey.org.uk
