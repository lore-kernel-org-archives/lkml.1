Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbXGNDZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbXGNDZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXGNDZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:25:36 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:53461 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXGNDZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:25:36 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: linux-kernel@vger.kernel.org
Subject: Re: The art of breaking userspace (was Re: [GIT] SELinux changes for 2.6.23 (updated))
Date: Fri, 13 Jul 2007 23:20:39 -0400
User-Agent: KMail/1.9.6
References: <3267153665.17485311@mail.hp.com> <4697CDB5.1060708@googlemail.com> <1184354963.3392.394.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1184354963.3392.394.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707132320.40024.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 13 2007 3:29:23 pm Stephen Smalley wrote:
> Agreed, it needs to be fixed in the netlabel code.

For anyone interested, and for the sake of completeness, an updated patch[set] 
has been posted to the SELinux mailing list for review.  The new patchset is 
designed to fix the problem that Michal reported.

-- 
paul moore
linux security @ hp
