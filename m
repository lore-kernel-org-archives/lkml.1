Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYHYJTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYHYJTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYHYJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:39237 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596AbYHYJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:30 -0400
Date: Mon, 25 Aug 2008 19:12:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, SELinux <selinux@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: Re: [PATCH 1/1] selinux: add support for installing a dummy policy
In-Reply-To: <20080823023812.GA30915@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0808251911050.32555@tundra.namei.org>
References: <20080822193413.GA8401@us.ibm.com> <alpine.LRH.1.10.0808230852320.24779@tundra.namei.org> <20080823023812.GA30915@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Serge E. Hallyn wrote:

> Good point.  Where would people who'd want to use this be most
> likely to look, in a scripts/selinux/README, or in
> Documentation/selinux or Documentation/security/selinux or
> somesuch?

There's Smack documentation under Documentation/, so perhaps next to that, 
with a pointer to it in scripts/selinux/README.


- James
-- 
James Morris
<jmorris@namei.org>
