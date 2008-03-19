Return-Path: <linux-kernel-owner+w=401wt.eu-S940977AbYCSWYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940977AbYCSWYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935955AbYCSVDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:53831 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935490AbYCSVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=hcu/LtSHC95x+wtOwZt/1R7x4AatMpnHPPUE2m8TpyrgwsRp/62ysNAMXGFGNBb7qv7cbm5+V0jxnxz2qSddlLuwSa527YufE0H7gg/0kr5e71+Vcz5TgHYy5FLBoH8oTA87N27adHJrPkZxCo7n7g94i6exYMNZdxtDdk79Pa0=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 00/12] mm/x86: bootmem
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 804
Date: Wed, 19 Mar 2008 14:03:07 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191403.07512.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resending some patches about bootmem 

some already in mm or x86

please keep the apply sequence.

YH
