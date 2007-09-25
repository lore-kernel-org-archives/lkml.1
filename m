Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXIYHCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXIYHCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXIYHCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:02:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:7870 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXIYHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kvWpkksHG6wVYkAfSBXm6nYzItcRdJskrHaDxkCY6n4+nHnrQ0kzVruL9G+6+AUTYclViRjd8qNTNDuCecaf7DcDxS3TSfyxD+T0BjjFAnuC+xIjEoOdSWwPwZV/a6bL0mt7MGnA3fS6Izb7WpAOXIWsvXeF4JgwC3yO2iM0N9g=
Message-ID: <661de9470709250002u73c1089dx94870586ce23b5b5@mail.gmail.com>
Date: Tue, 25 Sep 2007 12:32:42 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc7-mm1: panic in scheduler
Cc: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <46F82C88.1080907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190668373.5030.10.camel@localhost>
	 <46F82C88.1080907@linux.vnet.ibm.com>
X-Google-Sender-Auth: bc91c80bede0f873
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Exactly same call trace is produced over IA64 Madison (up to 9M cache) with 8 cpu's.
> --

Hi, Kamalesh,

Could you please reproduce the problem or share the steps to reproduce
the problem?

Thanks,
Balbir
