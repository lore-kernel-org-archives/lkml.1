Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXHGGVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXHGGVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXHGGU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:20:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:54864 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751143AbXHGGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:20:56 -0400
Message-ID: <46B80F46.8070804@snapgear.com>
Date: Tue, 07 Aug 2007 16:20:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: uclinux patches submission and author credit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Mon, 2007-08-06 at 17:36 +0200, Philippe De Muyter wrote:
 > Hi Andrew and Greg,
 >
 > Currently, all the patches that are submitted via Greg are marked as
 > authored by Greg.  Actually, the author is named in the first
 > Signed-off-by line (often Greg himself, sometimes someone other).
 >
 > Would it be possible to fix the patch submission scheme so that the real
 > author is credited ?

Currently if I submit a patch that was sent to me with a
Signed-off-by line I just add mine underneath it and send.
If the patch didn't come with a Signed-off-by then I put the
original author in a "From" line at the top of the submission.
Looks like I should always add a "From" line.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
