Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYFCOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYFCOa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYFCOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:30:06 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14929 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbYFCOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:30:04 -0400
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 10:30:04 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-tiny@selenic.com
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Date: Tue, 3 Jun 2008 16:06:29 +0200
User-Agent: KMail/1.9.7
Cc: David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <1212500751.16924.322.camel@pmac.infradead.org>
In-Reply-To: <1212500751.16924.322.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031606.29574.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe change the Kconfig entry so that:

* with CONFIG_EMBEDDED=y it's configuration
* with CONFIG_EMBEDDED=n it's on by default
