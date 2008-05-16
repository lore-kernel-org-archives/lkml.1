Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbYEPSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbYEPSxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbYEPSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:52:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762940AbYEPSwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:52:05 -0400
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
Subject: notification for systemtap-related oops
References: <482DB93B.2080100@linux.intel.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 16 May 2008 14:50:29 -0400
In-Reply-To: <482DB93B.2080100@linux.intel.com> (Arjan van de Ven's message of "Fri, 16 May 2008 09:41:31 -0700")
Message-ID: <y0mskwif5hm.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

Arjan, would it be possible for kerneloops.org to notify us systemtap
people (cc:d) automagically if the oops messages implicate systemtap
modules by including "stap_.*" in the loaded-module list or stack
backtrace symbols?

- FChE
