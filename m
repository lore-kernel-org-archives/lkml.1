Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZCEMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZCEMNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZCEMMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:12:50 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:22276
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751849AbZCEMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:49 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG18KZ-02-DE8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] various x86 kvm fixes
Date: Thu, 5 Mar 2009 13:12:27 +0100
Message-ID: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0686 (UTC) FILETIME=[AA1DBB60:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

this small series of patches collects some fixes I have collected during
the last days of KVM hacking. Please review and comment or apply if
appropriate :)

Joerg



