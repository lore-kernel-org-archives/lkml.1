Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXHVOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXHVOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760494AbXHVOIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:08:30 -0400
Received: from namei.org ([69.55.235.186]:35448 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760232AbXHVOI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:08:29 -0400
Date: Wed, 22 Aug 2007 07:08:16 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
In-Reply-To: <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
References: <20070822083844.%N@1wt.eu>  <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
  <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au> 
 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Stephen Smalley wrote:

> Oops, never mind - tail still follows secmark, so that shouldn't matter.
> So I'm not sure why we are getting a bad value for secmark here - should
> be initialized to zero and never modified unless there is an iptables
> secmark rule.

Michal, do you see this in current git?


-- 
James Morris
<jmorris@namei.org>
