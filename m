Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbZA2SK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbZA2SK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZA2SKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:10:17 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:39509 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2SKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:10:16 -0500
Date: Thu, 29 Jan 2009 19:10:14 +0100
From: Peter Palfrader <weasel@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Tkac <vonsch@gmail.com>, linux-kernel@vger.kernel.org,
       debian-admin@lists.debian.org, team@security.debian.org,
       libpam-modules@packages.debian.org, stable@kernel.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090129181014.GO2469@anguilla.noreply.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Adam Tkac <vonsch@gmail.com>, linux-kernel@vger.kernel.org,
	debian-admin@lists.debian.org, team@security.debian.org,
	libpam-modules@packages.debian.org, stable@kernel.org
References: <20090121115219.GA2754@anguilla.noreply.org> <20090127151703.c356c5db.akpm@linux-foundation.org> <20090129121900.GA2827@evileye.atkac.englab.brq.redhat.com> <20090129100509.6969970f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090129100509.6969970f.akpm@linux-foundation.org>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Andrew Morton wrote:

> Sure, debian might well be wrong.  But the bottom line is that the
> kernel changed, and people's machines broke.
> 
> If the kernel change was really really important then we might just
> grit our teeth and live with the breakage.  But this change _wasn't_ a
> terribly important one.  So I think we should back it out while we find
> another way of implementing it which does not break currently deployed
> installations.

FWIWs, if Debian stable (4.0) is really the only place that breaks with
this then re-introducing it in a couple of months when the new version
of Debian (5.0) has been out for a while might well be an option.

Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
