Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYKINW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYKINW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYKINWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:22:49 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46898 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbYKINWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:22:48 -0500
X-Sasl-enc: n4qHFPYI3QMTBOce5+fPmnKc8d8eKjBq6z8oAKFOk1vg 1226236966
Date: Sun, 9 Nov 2008 11:22:44 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [GIT PATCH] thinkpad-acpi regression fix for
	2.6.28-rc
Message-ID: <20081109132244.GA12794@khazad-dum.debian.net>
References: <20081109113011.GB8329@khazad-dum.debian.net> <1226235242-11130-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226235242-11130-1-git-send-email-hmh@hmh.eng.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Nov 2008, Henrique de Moraes Holschuh wrote:
> This patch should fix a reported regression on fan_resume (not
> on bugzilla, report on the LKML and ibm-acpi-devel).

Spoke too soon.  Bugzilla #11982.  I've sent the patch there as well.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
