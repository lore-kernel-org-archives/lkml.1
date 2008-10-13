Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYJMRS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYJMRS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbYJMRSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:18:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55906 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYJMRSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:18:12 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: [PATCH 0/3] integrity 
Date: Mon, 13 Oct 2008 13:17:28 -0400
Message-Id: <cover.1223869200.git.zohar@localhost.localdomain>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting the integrity patchset based on James's security-testing-2.6/#next
tree as per his request.

Mimi Zohar (3):
  integrity: TPM internel kernel interface
  integrity: Linux Integrity Module(LIM)
  integrity: IMA as an integrity service provider
