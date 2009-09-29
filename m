Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZI2RS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZI2RS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZI2RS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:18:28 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:63704 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZI2RS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:18:27 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2009 13:18:27 EDT
Message-ID: <4AC23F3A.1010808@freemail.hu>
Date: Tue, 29 Sep 2009 19:09:14 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc1 vs 2.6.32-rc2?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32711; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems that there is a little typo in EXTRAVERSION: the title is
Linux 2.6.32-rc1 and the version in the EXTRAVERSION in Makefile
is -rc2, see http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=17d857be649a21ca90008c6dc425d849fa83db5c

Regards,

	Márton Németh
