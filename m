Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZJ0QJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZJ0QJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZJ0QJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:09:58 -0400
Received: from kuber.nabble.com ([216.139.236.158]:39071 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZJ0QJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:09:57 -0400
Message-ID: <26080408.post@talk.nabble.com>
Date: Tue, 27 Oct 2009 09:10:02 -0700 (PDT)
From: Patrik Kluba <kpajko79@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PREEMPT_RCU on UP
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: kpajko79@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

Does the preemptible RCU implementation have better performance (lower
latency?) than the classic RCU implementation on embedded uniprocessor
systems? I can't find any information about this in Documentation/.

Regards,
Patrik Kluba

-- 
View this message in context: http://www.nabble.com/PREEMPT_RCU-on-UP-tp26080408p26080408.html
Sent from the linux-kernel mailing list archive at Nabble.com.

