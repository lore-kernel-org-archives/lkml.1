Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZD0Qkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZD0Qkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZD0Qka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:40:30 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:35059 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755468AbZD0Qk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:40:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=K3LmAoAlUujWbUcIktvMUunU0JYE/L2qJWjstqcaWlYioEkJb3BFSeJMmnxeNnvwMGi79SjbtFld/dcNX4QQnp4M4ZPeaRyBa0Lu8qiwW/IZU+2BGXdtWtns3ZuxK+ZJ;
Date: Mon, 27 Apr 2009 09:36:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Bennee" <kernel-hacker@bennee.com>
Subject: Re: [Bug #13171] 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS =
 corruption
Message-ID: <20090427093655.3d498003@hobbes>
In-Reply-To: <Fg2zLW93smL.A.XrC.0c48JB@chimera>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	<Fg2zLW93smL.A.XrC.0c48JB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 21:31:50 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13171
> Subject		: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS
> = corruption Submitter	: Alex Bennee <kernel-hacker@bennee.com>
> Date		: 2009-04-19 6:27 (7 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=124022460014812&w=4

I'm curious about this one... we pushed some display setup related
fixes recently so things should be working well in all configs now
afaik.

Alex can you post your X log?

-- 
Jesse Barnes, Intel Open Source Technology Center
