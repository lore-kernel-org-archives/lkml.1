Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbXGSMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbXGSMhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbXGSMhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:37:38 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:38669 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXGSMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:37:37 -0400
Date: Thu, 19 Jul 2007 08:37:34 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Christian Ehrhardt <lk@c--e.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <20070719122424.GA5186@vino.hallyn.com>
Message-ID: <Line.LNX.4.64.0707190832290.4303@d.namei>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
 <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de>
 <20070719122424.GA5186@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Serge E. Hallyn wrote:

> If we could get a few (non-afilliated :) people who work with
> customers in the security field to tell us whether this is being
> used, that would be very helpful.  Not sure how to get that.

The mainline kernel does not cater to out of tree code.

> Or we just apply the patch and see who yells  :)


It's already pretty clear.



- James
-- 
James Morris
<jmorris@namei.org>
