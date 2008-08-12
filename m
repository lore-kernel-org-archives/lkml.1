Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYHLN3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYHLN3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYHLN3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:29:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYHLN3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:29:22 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] Introduce credentials API
To: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org
Cc: dhowells@redhat.com, davem@davemloft.net, sfrench@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Tue, 12 Aug 2008 14:28:40 +0100
Message-ID: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi James, Andrew,

Here are the patches that are necessary just to add the credentials wrapper
API as Stephen suggested.

There are two patches: the first renames some things in XFS that would
otherwise collide in the namespace, and the second adds the wrappers in no-op
forms.

David
