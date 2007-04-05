Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXDERGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXDERGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXDERGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:06:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56436 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXDERGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:06:47 -0400
Date: Thu, 5 Apr 2007 22:44:13 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070405171413.GK28414@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com> <20070403175101.GN2456@in.ibm.com> <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com> <20070404030756.GA9008@in.ibm.com> <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com> <20070404051526.GA16562@in.ibm.com> <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com> <20070404172643.GA28328@in.ibm.com> <6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com> <20070405165752.GA13687@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405165752.GA13687@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 10:27:52PM +0530, Srivatsa Vaddagiri wrote:
> Ok ..by posting rcfs patches, I didn't mean to introduce a "yours" and
> "mine" rift ..honestly.  In fact you would notice that they have your
> (sole) copyright still on them! It took me just two days to convert over the
> patches to use nsproxy and come up with the rcfs patches and obviously I
> couldnt have done that without your excellent patches to start with.

By doing rcfs, I have been able to do a much better review of your 
patches than by just browsing thr' the code. I hope you would find usefull some 
of the feedback I have sent so far on the container patches ..

-- 
Regards,
vatsa
