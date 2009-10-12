Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZJLNkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZJLNkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZJLNkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:40:24 -0400
Received: from mail.tpi.com ([70.99.223.143]:3403 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZJLNkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:40:23 -0400
Message-ID: <4AD33198.6020704@canonical.com>
Date: Mon, 12 Oct 2009 07:39:36 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Candidate for stable: e1000e: swap max hw supported frame size between
 82574 and 82583
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a825e00c98a2ee37eb2a0ad93b352e79d2bc1593 seems like a good
candidate for stable (if you've not already been notified).

rtg
-- 
Tim Gardner tim.gardner@canonical.com
