Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXJZGss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXJZGss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJZGsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:48:41 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65485 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbXJZGsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:48:40 -0400
Message-ID: <47218DBC.8070404@bx.jp.nec.com>
Date: Fri, 26 Oct 2007 15:48:28 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: gregkh@suse.de, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/2] Japanese translation of Documentation/SubmittingPatches
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Hi all,

Currently, HOWTO and stable_api_nonsense.txt are included in 
Documentation/"each country"/ as policy documents.
Greg K-H said the following in this thread:
(http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/0897.html)

> So I really do want to see a translated copy of the HOWTO,
> stable-api-nonsense.txt, and possibly a few other files in the main
> kernel tree (SubmittingPatches, CodingStyle, and SubmittingDrivers might
> all be good canidates for this.)  These files change relativly
> infrequently (the HOWTO file has had only 7 changes in 1 and 1/2 years,
> and they were very minor ones) and should be easy for the translators to
> keep up with.

SubmittingPatches document includes important information 
about how to generate patch and write e-mail related to kernel 
development.

So, I wish SubmittingPatches is included in Documentation/"each country"/ 
as policy documents.
How do you think about this?

I attach two patches(one fixes a typo, the other adds SubmittingPatches 
translated into Japanese to Documentation/ja_JP directory).
These patches are for linux-2.6.23.

The translated SubmittingPatches has already been reviewed by JF project.
JF project is the Japanese equivalent of LDP.

Your comments are very welcome.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

