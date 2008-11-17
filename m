Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYKQCOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYKQCOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYKQCON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:14:13 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35109 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbYKQCOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:14:12 -0500
X-Sasl-enc: hve79meezjP6HLMdadLE0jcZZA8xY+FjSdYxp9hB6Bk/ 1226888051
Date: Mon, 17 Nov 2008 00:14:08 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: thinkpad-acpi: fix fan sleep/resume path
Message-ID: <20081117021408.GD22260@khazad-dum.debian.net>
References: <20081109113011.GB8329@khazad-dum.debian.net> <1226235242-11130-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226235242-11130-2-git-send-email-hmh@hmh.eng.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

The patch needs to go to Linus...  I don't think anyone cares to have
their names as tested-by:, or they would have replied already.

I have tested the patch and it fixes things here.  It would be better with
more "works for me" replies, but it should be enough testing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
