Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZARWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZARWf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZARWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:35:19 -0500
Received: from kuber.nabble.com ([216.139.236.158]:49347 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZARWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:35:18 -0500
Message-ID: <21534062.post@talk.nabble.com>
Date: Sun, 18 Jan 2009 14:35:17 -0800 (PST)
From: agent59624285 <agent59624285@spamcorptastic.com>
To: linux-kernel@vger.kernel.org
Subject: Signals mechanism question
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: agent59624285@spamcorptastic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
I read lately about the signals mechanism, and I have a couple of question
that I couldn't find the answer to them. it would be great if someone would
answer.

1. when handling a signal before changing to user Mode, the kernel copies
data to the user stack. what is the data that he saves in setup_frame()?
2. what signals are blocked while in the signal handler? could this mask be
changed?
3. when does a system call could be reentrant and when it cannot, when
disturbed by a signal?

thanks.
-- 
View this message in context: http://www.nabble.com/Signals-mechanism-question-tp21534062p21534062.html
Sent from the linux-kernel mailing list archive at Nabble.com.

