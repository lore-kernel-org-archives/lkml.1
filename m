Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbZD3THQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbZD3THQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbZD3TE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbZD3TE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:04:27 -0400
Message-ID: <49F9F5BF.2020700@zytor.com>
Date: Thu, 30 Apr 2009 12:02:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, jdb@comx.dk,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build
 of bzImage with 64 bit compiler
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org> <49F9BB47.7080806@zytor.com> <20090430150924.GA8656@uranus.ravnborg.org> <49F9D1E5.2090805@zytor.com> <20090430175259.GA9894@uranus.ravnborg.org>
In-Reply-To: <20090430175259.GA9894@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> So adding -ansi is trivial and will only hit .lds.S files.
> 
> I assume the lds files are named .S is because we shared rules
> long time ago.
> 

Yes, the naming is rather ugly that way.

	-hpa

