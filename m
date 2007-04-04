Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXDDRfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXDDRfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXDDRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:35:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45697 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXDDRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:35:03 -0400
Date: Wed, 4 Apr 2007 23:12:28 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070404174227.GB28414@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com> <20070403173048.GL2456@in.ibm.com> <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com> <20070403175101.GN2456@in.ibm.com> <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com> <20070404030756.GA9008@in.ibm.com> <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com> <20070404051526.GA16562@in.ibm.com> <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com> <20070404172643.GA28328@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404172643.GA28328@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 10:56:43PM +0530, Srivatsa Vaddagiri wrote:
> I think the null grouping as defined so far is very fuzzy ..How would
> the kernel use this grouping, which would require reserving N pointers 
> in 'struct container_group'/'struct nsproxy'?

aside from needing to support 'cat tasks' that is ..

-- 
Regards,
vatsa
