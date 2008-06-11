Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYFKHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYFKHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYFKHAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:00:04 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:11955 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYFKHAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:00:01 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] add diffconfig utility
Date: Wed, 11 Jun 2008 08:59:47 +0200
User-Agent: KMail/1.9.7
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <484ED902.9040000@am.sony.com>
In-Reply-To: <484ED902.9040000@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110859.47979.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice.

Would it be helpful to compare .config.old to .config if you 
don't provide any command line arguments?

scripts/diffconfig

would then do the job.
