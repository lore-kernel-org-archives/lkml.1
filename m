Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZHFXHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZHFXHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZHFXHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:07:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34011 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbZHFXHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:07:33 -0400
Message-ID: <4A7B622D.7090203@us.ibm.com>
Date: Thu, 06 Aug 2009 16:07:25 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
References: <4A7A1D48.7040309@us.ibm.com>
In-Reply-To: <4A7A1D48.7040309@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> NOT FOR INCLUSION

Please disregard this patch, it was ill-conceived.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
