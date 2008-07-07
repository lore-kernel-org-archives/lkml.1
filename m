Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYGGV4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYGGV4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbYGGV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:56:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46478 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbYGGV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:56:17 -0400
Subject: [PATCH 0/5] integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Content-Type: text/plain
Date: Mon, 07 Jul 2008 17:56:13 -0400
Message-Id: <1215467773.27626.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


