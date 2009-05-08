Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbZEHR0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbZEHR0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZEHRZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:25:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZEHRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:25:53 -0400
Message-ID: <4A046A2F.4050107@zytor.com>
Date: Fri, 08 May 2009 10:21:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the	decompressor
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com> <20090508075354.GA6132@lenovo> <4A0465E6.9000401@zytor.com> <20090508171556.GN6132@lenovo>
In-Reply-To: <20090508171556.GN6132@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> yeah, unfortunately I reveal that when my mail already gone.
> though I don't understand why 32 is there... could you please?
> 

See my answer to Sam asking the same question.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

