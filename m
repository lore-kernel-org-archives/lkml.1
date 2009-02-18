Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbZBRNJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbZBRNJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZBRNJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:09:26 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24420 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZBRNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:09:25 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KF9J71-03-C6L-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM SoftMMU fixes
Date: Wed, 18 Feb 2009 14:08:57 +0100
Message-ID: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 18 Feb 2009 13:09:00.0179 (UTC) FILETIME=[106D4E30:01C991CA]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

this small patch series fixes two issues and include one cleanup I ran
into hacking in the KVM SoftMMU code. Please consider to apply.

Joerg

diffstat:

 arch/x86/kvm/mmu.c  |   10 +++-------
 virt/kvm/kvm_main.c |    6 ++++--
 2 files changed, 7 insertions(+), 9 deletions(-)



