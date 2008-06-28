Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYF1WcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYF1WcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYF1WcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:32:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYF1WcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:32:13 -0400
Message-ID: <4866BBC0.3000503@zytor.com>
Date: Sat, 28 Jun 2008 15:31:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Anders H Kaseorg <andersk@MIT.EDU>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Patch paravirt inline replacements when loading
 modules
References: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders H Kaseorg wrote:
> Paravirt replacements were added to the i386 module loader by commit
> 139ec7c416248b9ea227d21839235344edfee1e0.  This adds the same code to
> the x86_64 module loader.

Not having looked at this in detail, is this a *current* problem or a 
*future* problem, i.e. does it fix a bug that's currently in the kernel?

	-hpa
