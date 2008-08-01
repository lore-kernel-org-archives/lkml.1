Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYHAJik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYHAJik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYHAJi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:28 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHAJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aJjojQmG77NnE57PMjj99Ngz0Q+2TSgrg4v/gDtCjmAe5Qmlhiq/Y3i7WizpBNFgKi
         vq71mPLhdWk2H9RVxhBEEp1xahCrbJvNEm4fcyKq5YWVva5CnY9XKZDVFxHUM+Dvrxwc
         5L1TXPryBexko0e5gcFkWU1180uPwS6a7b1YE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/16] dyn_array and nr_irqs support v2
Date: Fri,  1 Aug 2008 02:37:28 -0700
Message-Id: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check dyn_array support for x86

Thanks

Yinghai Lu

