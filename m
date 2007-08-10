Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbXHJXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbXHJXcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXHJXci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:32:38 -0400
Received: from mail.suse.de ([195.135.220.2]:40523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXHJXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:32:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Gollub <dgollub@suse.de>
Subject: Re: [PATCH] Fix to keep watchdog disabled by default for i386/x86_64
Date: Sat, 11 Aug 2007 01:32:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708110029.52369.dgollub@suse.de>
In-Reply-To: <200708110029.52369.dgollub@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708110132.34522.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +#deifne NMI_DEFAULT	NMI_DISABLED

Actually tested?

-Andi
