Return-Path: <linux-kernel-owner+w=401wt.eu-S935383AbYBUWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383AbYBUWpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbYBUWpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:45:03 -0500
Received: from phunq.net ([64.81.85.152]:59815 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753424AbYBUWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:45:00 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Thu, 21 Feb 2008 14:44:04 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <28196.1203605703@redhat.com>
In-Reply-To: <28196.1203605703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211444.04986.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I am trying to spot the numbers that show the sweet spot for this 
optimization, without much success so far.

Who is supposed to win big?  Is this mainly about reducing the load on 
the server, or is the client supposed to win even with a lightly loaded 
server?

When you say Ext3 cache vs NFS cache is the first on the server and the 
second on the client?

Regards,

Daniel
