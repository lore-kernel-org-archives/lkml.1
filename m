Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYHYMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYHYMSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYHYMSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:18:32 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:55310 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYHYMSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:18:31 -0400
Subject: Re: [PATCH 1/1] selinux: add support for installing a dummy policy
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       SELinux <selinux@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
In-Reply-To: <alpine.LRH.1.10.0808251911050.32555@tundra.namei.org>
References: <20080822193413.GA8401@us.ibm.com>
	 <alpine.LRH.1.10.0808230852320.24779@tundra.namei.org>
	 <20080823023812.GA30915@us.ibm.com>
	 <alpine.LRH.1.10.0808251911050.32555@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 25 Aug 2008 08:16:55 -0400
Message-Id: <1219666615.2721.32.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-25 at 19:12 +1000, James Morris wrote:
> On Fri, 22 Aug 2008, Serge E. Hallyn wrote:
> 
> > Good point.  Where would people who'd want to use this be most
> > likely to look, in a scripts/selinux/README, or in
> > Documentation/selinux or Documentation/security/selinux or
> > somesuch?
> 
> There's Smack documentation under Documentation/, so perhaps next to that, 
> with a pointer to it in scripts/selinux/README.

In that case, we really ought to have a general introduction to SELinux
there first, and then include description of this dummy policy and a
pointer to the reference policy as part of that text.

-- 
Stephen Smalley
National Security Agency

