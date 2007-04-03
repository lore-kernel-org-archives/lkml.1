Return-Path: <linux-kernel-owner+w=401wt.eu-S965920AbXDCR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920AbXDCR0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXDCR0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:26:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53890 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965920AbXDCR03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:26:29 -0400
Date: Tue, 3 Apr 2007 23:04:00 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403173400.GM2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com> <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com> <20070403171155.GK2456@in.ibm.com> <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:10:35AM -0700, Paul Menage wrote:
> Agreed. So I'm not saying it's fundamentally a bad idea - just that
> merging container_group and nsproxy is a fairly simple space
> optimization that could easily be done later.

IMHO, if we agree that space optimization is important, then its better
we tackle it right at design phase, rather than ripping it out later ..

-- 
Regards,
vatsa
