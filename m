Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZL0A1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZL0A1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 19:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZL0A1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 19:27:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60501 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbZL0A1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 19:27:01 -0500
X-Sasl-enc: LHnujj8X0w4lmeC8UomF/ptWEfStW9uWfPyJgY4ofoi8 1261873620
Date: Sat, 26 Dec 2009 22:26:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFT] Input: speed up suspend/shutdown for PS/2 mice and
 keyboards
Message-ID: <20091227002658.GB26593@khazad-dum.debian.net>
References: <20091221070951.GA4170@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221070951.GA4170@core.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works on my ThinkPad T43 (KBC emulated by the embedded controller firmware),
although I don't think it made much difference in speed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
