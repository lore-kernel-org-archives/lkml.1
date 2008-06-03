Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYFCR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYFCR7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYFCR7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:59:31 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37060 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYFCR7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:59:30 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <44F7F2AB-6AC1-457C-A90F-C0927B567F4A@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <1212515734.11008.49.camel@brick>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] bluetooth: remove private bitrev16 implementation
Date: Tue, 3 Jun 2008 19:59:28 +0200
References: <1212515734.11008.49.camel@brick>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

> Expose bitrev16 from lib/bitrev.c and use it.

can you please split these into two patches. One that exports bitrev16  
properly and the other one that fixes the Bluetooth driver.

Regards

Marcel

