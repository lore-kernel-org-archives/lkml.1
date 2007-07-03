Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXGCPPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXGCPPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXGCPPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:15:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33202 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758723AbXGCPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:15:17 -0400
X-Sasl-enc: 5UKUI4NRfNmdvkJKfGsYEUijdYUAhE6dhm0pyNkKIp0X 1183475717
Date: Tue, 3 Jul 2007 12:15:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tim Boneko <tim@boneko.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Old bug in tg3 driver unfixed?
Message-ID: <20070703151513.GB32367@khazad-dum.debian.net>
References: <46864736.3090108@boneko.de> <20070702235901.GA9713@atjola.homenet> <468A64F0.4000308@boneko.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468A64F0.4000308@boneko.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007, Tim Boneko wrote:
> are three rules in /etc/udev/rules.d/z25_persistent-net.rules dealing
> with eth0 - eth2, they state MAC addresses which don't match. I
> certainly didn't put them there. Does udev change its own config?

In Debian, yes.  Read the ones with "generator" in the name.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
