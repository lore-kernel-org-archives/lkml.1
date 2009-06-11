Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZFKPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZFKPF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZFKPFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:05:15 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:33697 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZFKPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:05:14 -0400
Message-ID: <4A311D2A.808@xs4all.nl>
Date: Thu, 11 Jun 2009 17:05:14 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-rt@vger.kernel.org
Subject: NOHZ: local_softirq_pending 10
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found a few of these in my 2.6.29.4-rt16 logs:

NOHZ: local_softirq_pending 10

Are they rt-related?
(I saw them in older kernels without -rt as well)
How serious? How to fix?

Kind regards,
Udo
