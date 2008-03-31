Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYCaCGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYCaCGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCaCFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:05:54 -0400
Received: from intmailgate.algonquincollege.com ([205.211.52.150]:43062 "EHLO
	mailgate4.algonquincollege.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644AbYCaCFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:05:53 -0400
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2008 22:05:53 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Eric Descourtis <desc0068@algonquincollege.com>
To: linux-kernel@vger.kernel.org
Cc: eric.des.courtis@gmail.com
Message-id: <fbb49c58d56e.47f0403c@algonquincollege.com>
Date: Mon, 31 Mar 2008 01:37:00 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-4.01 (built Aug  3 2007;
 32bit)
Content-language: en
Subject: Limiting CPU usage for processes in linux 2.6.18.8
X-Accept-Language: en
X-Canit-CHI2: 0.00
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, Outgoing)
X-Spam-Score: 0.00 () [Hold at 12.00] 
X-CanItPRO-Stream: Outgoing (inherits from default)
X-Canit-Stats-ID: 65212591 - 57b888ff0ad5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to implement a patch to the scheduler that limits the CPU usage of individual 
processes to a percentage in Linux 2.6.18.8 (Can't be any other version). 
I would just like some feedback on the following questions:
 
1. How can I ensure that limited processes get their CPU time percentage allocation?
2. Are there mechanisms in place that would simplify this process?

I have been hitting my head against the wall for a long time now, any help would be appreciated. 
 
Thank you.

Eric des Courtis
CC: eric.des.courtis@gmail.com
