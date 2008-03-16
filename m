Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYCPR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYCPR1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 13:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYCPR1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 13:27:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55504 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYCPR1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 13:27:10 -0400
X-Sasl-enc: 4nQ7hag/Xjpo4vDocCfixi+XPQyPDsIqaTx3fdMBvjmD 1205688429
Date: Sun, 16 Mar 2008 14:27:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: N?meth M?rton <nm127@freemail.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LED: add support to leds with readable status
Message-ID: <20080316172706.GE19825@khazad-dum.debian.net>
References: <1205686229-23408-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205686229-23408-1-git-send-email-hmh@hmh.eng.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

Thinkpad-acpi LED support needs this patch...

Code using this feature is available for a quick peek at:
http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git?a=shortlog;h=refs/heads/devel

and I'd like to submit for merging during 2.6.26's merge window (which means
it needs to go to acpi-test soon).

I need your opinion on the patch, and to know where you will accept it for
2.6.26 or not, in order to plan my submission path for the stuff that
depends on it.

It applies cleanly on top of your for-mm branch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
