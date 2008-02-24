Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYBXJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYBXJDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 04:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYBXJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 04:03:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47287 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYBXJDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 04:03:13 -0500
Date: Sun, 24 Feb 2008 10:03:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Priit Laes <plaes@plaes.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix build on non-C locales.
Message-ID: <20080224090324.GA8169@uranus.ravnborg.org>
References: <1203807950.12128.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203807950.12128.4.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prit.

Could we just use [[:alnum:]] and drop the setting of LC_ALL?

	Sam
