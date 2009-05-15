Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbZEOPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbZEOPVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZEOPVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:21:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZEOPVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:21:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: pm-susend on 2.6.30-rc5
Date: Fri, 15 May 2009 17:20:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
References: <43e72e890905131833k291c8720r4045e9e497430b40@mail.gmail.com>
In-Reply-To: <43e72e890905131833k291c8720r4045e9e497430b40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151720.51731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Luis R. Rodriguez wrote:
> When trying suspend on 2.6.30-rc5 I get the following WARN and also
> cannot use my write to my file system. I cannot even reboot:

Can you attach the .config, please?

Rafael
