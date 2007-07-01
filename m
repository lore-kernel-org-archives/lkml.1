Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbXGAOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbXGAOZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXGAOZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 10:25:12 -0400
Received: from main.gmane.org ([80.91.229.2]:52990 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbXGAOZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 10:25:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: "Daniel J. Priem" <daniel+news@flexserv.de>
Subject: howto disable vlantag in tg3
Date: Sun, 01 Jul 2007 16:19:57 +0200
Organization: Flexserv
Message-ID: <87zm2g6waa.fsf@samuel.flexserv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 213.217.69.53
Mail-Copies-To: never
X-GPG-ID: 0x7B196671
X-GPG-FP: A9CE 5788 44D3 A1A2 46B6  A727 53D8 DD4B 7B19 6671
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Cancel-Lock: sha1:Af3nQXN6jpsglBUVzOal6UOz/u4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the tg3 module automatically removes any incoming vlantags from packets.
how can i stop this on 2.6.18?
is there some hidden echo foo > /sys/...
or modprobe options tg3 dontusetagbla?

Thanks
Daniel

