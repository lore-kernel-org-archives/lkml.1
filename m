Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZI3UwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZI3UwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZI3UwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:52:14 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:41362 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531AbZI3UwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:52:13 -0400
Date: Wed, 30 Sep 2009 16:47:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: "Luck, Tony" <tony.luck@intel.com>
cc: Tejun Heo <teheo@suse.de>, Nick Piggin <npiggin@suse.de>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic percpu
 and drop the old one, take#2
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E2F03E58@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.1.10.0909301644460.9271@gentwo.org>
References: <1253682382-24740-1-git-send-email-tj@kernel.org> <4AC153EA.2050007@suse.de> <57C9024A16AD2D4C97DC78E552063EA3E2F03E58@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Great. Ill post a new rev of the per cpu ops patchset.

Tony: Could we use a global register for the per cpu address? That would
make IA64 work similar to sparc.


