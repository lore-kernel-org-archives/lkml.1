Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYDTIPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYDTIPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYDTIPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:15:19 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1917 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYDTIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:15:17 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 04:15:17 EDT
Message-ID: <480AFA0A.7070404@xs4all.nl>
Date: Sun, 20 Apr 2008 10:08:42 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25 section mismatches and isdn
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When building 2.6.25 I see:

WARNING: modpost: Found 10 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

How harmless are these?


Also, after booting, my w6692-based isdn card stopped showing it's
device files in /dev. Has always worked without a problem.
Could there be a relation?

Kind regards,
Udo

