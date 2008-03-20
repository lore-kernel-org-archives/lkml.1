Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYCTWHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYCTWHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbYCTWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:07:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678AbYCTWHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:07:01 -0400
Date: Thu, 20 Mar 2008 18:04:55 -0400
From: Rik van Riel <riel@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       menage@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, veillard@redhat.com
Subject: Re: [RFC] libcg: design and plans
Message-ID: <20080320180455.7c179008@cuia.boston.redhat.com>
In-Reply-To: <20080304152341.GB5659@linux.vnet.ibm.com>
References: <20080304152341.GB5659@linux.vnet.ibm.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 20:53:41 +0530
Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi,
> 
> We have been working on a library for control groups which would provide
> simple APIs for programmers to utilize from userspace and make use of
> control groups.

Since somebody (*cough*openvz*cough*) will no doubt add security and
network separation to the control groups at some point in the future,
why not build on libvirt?

That way admins can also use the same tools for monitoring and managing
resource groups that they use for virtual machines.

http://libvirt.org/

-- 
All Rights Reversed
