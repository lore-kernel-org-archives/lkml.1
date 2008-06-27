Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYF0QWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYF0QWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbYF0QV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:21:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34928 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYF0QV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:21:56 -0400
Subject: [RFC][PATCH 0/5] integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 12:21:50 -0400
Message-Id: <1214583710.28077.13.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments for a redesign of the integrity patches.
This patchset contains 5 patches.
        Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
        Patch 2/5 integrity: TPM internal kernel interface
        Patch 3/5 integrity: special fs magic
        Patch 4/5 integrity: Linux Integrity Module(LIM)
        Patch 5/5 integrity: IMA as an integrity service provider

Attached to this patchset thread is an IMA LTP patch, which tests
adding file integrity measurements, replacing the default integrity
measurement policy with an LSM constrained policy, and adding
memory integrity measurements, using the example kmem-template.

Mimi Zohar

