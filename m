Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYJOP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYJOP4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYJOP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:56:09 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59135 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYJOP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kbw1PKE0GF+wz2YIsDWXT81+cG+nAp6X0CncBuhKB1DL6efcNnNYsmLvrfmCvYxWkV
         Ldq5yI89sHXhVrTZA2yV7Db13TMrw2F0e56SVCS+ZlmDRKEgua+G+pbEk72ahctlXX7U
         7sZll6Wa3ZMDnQ1cHIM/YAa0S9uoHdQnLIi3I=
Message-ID: <b6a2187b0810150856qa283c88oc2958c485b718b8c@mail.gmail.com>
Date: Wed, 15 Oct 2008 23:56:05 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Cc: "Ingo Molnar" <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20081015144626.GC7829@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
	 <20081015112324.GB31476@elte.hu>
	 <b6a2187b0810150502m3b363b90q106102578e92811d@mail.gmail.com>
	 <20081015120558.GA23347@elte.hu>
	 <b6a2187b0810150639j37ed3be6v3c800fb7d3a4a1f0@mail.gmail.com>
	 <20081015144626.GC7829@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:46 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:

> Jeff, Does the appended patch fix the issue? Thanks.

Yes, it does.

Thanks,
Jeff.
