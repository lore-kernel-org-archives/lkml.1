Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYEYSI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYEYSI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYEYSIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:08:20 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:52096 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYEYSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:08:20 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re:[PATCH -v4] x86: enable preemption in delay
Date: Sun, 25 May 2008 21:08:24 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252108.25011.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

look at this patch, proposed by me and Ingo few month ago.
I think it solves the problem you had fond, but unfortunately
it had been lost (not included in the mainline).

http://lkml.org/lkml/2007/11/20/343

It is against the kernel at the moment the message was sent.
I think it could be applied to the current kernel too.

Best regards

Marin Mitov
