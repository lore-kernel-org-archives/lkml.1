Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZFEJCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZFEJCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZFEJCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:02:40 -0400
Received: from main.gmane.org ([80.91.229.2]:39560 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZFEJCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:02:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Reinhard Tartler <siretart@tauware.de>
Subject: Re: [RFC] CPU hard limits
Date: Fri, 05 Jun 2009 11:02:20 +0200
Message-ID: <87r5xzuk83.fsf@faui44a.informatik.uni-erlangen.de>
References: <20090604053649.GA3701@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-88-217-123-97.dynamic.mnet-online.de
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
Cancel-Lock: sha1:fFyNqTYa0JBsEcmf70KfRN8vPuU=
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao <bharata@linux.vnet.ibm.com> writes:

> 4. Existing solutions
> ---------------------
> - Both Linux-VServer and OpenVZ virtualization solutions support CPU hard
>   limiting.
> - Per task limit can be enforced using rlimits, but it is not rate
> based.

Also related work:

http://www.usenix.org/events/osdi99/full_papers/banga/banga.pdf

it has even had a preliminary linux implementation from 2003, which has
been proposed at that time, but wasn't considered.

http://admingilde.org/~martin/rc/

maybe someone wants to pick up that work?


-- 
Gruesse/greetings,
Reinhard Tartler, KeyID 945348A4

