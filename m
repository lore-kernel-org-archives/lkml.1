Return-Path: <linux-kernel-owner+w=401wt.eu-S1764760AbYCDSFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764760AbYCDSFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbYCDSF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:05:29 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44808 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbYCDSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:05:28 -0500
Subject: Re: [RFC] libcg: design and plans
From: Dave Hansen <haveblue@us.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       containers@lists.linux-foundation.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, menage@google.com
In-Reply-To: <20080304152341.GB5659@linux.vnet.ibm.com>
References: <20080304152341.GB5659@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 10:05:12 -0800
Message-Id: <1204653912.32542.69.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 20:53 +0530, Dhaval Giani wrote:
> We have been working on a library for control groups which would provide
> simple APIs for programmers to utilize from userspace and make use of
> control groups.

What kinds of things are lacking the the cgroup interface that you want
to make up for in this library?

-- Dave

