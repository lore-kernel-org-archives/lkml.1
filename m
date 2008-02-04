Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYBDAyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYBDAyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYBDAyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:54:31 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:35630 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754103AbYBDAya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:54:30 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH] per-process securebits
Date: Mon, 4 Feb 2008 02:54:50 +0200
User-Agent: KMail/1.9.8
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
References: <47A2D439.9050704@kernel.org> <200802030825.49221.ismail@pardus.org.tr> <47A66119.90702@kernel.org>
In-Reply-To: <47A66119.90702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802040254.50444.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Monday 04 February 2008 around 02:49:29 Andrew G. Morgan wrote:
> Another way to put this is that there needs to be some application code
> and documentation available to guide the way... Adding such things to
> the example programs in libcap2 helped me find the 24-rc2 CAP_SETPCAP
> bug and until I've gone through the task of testing all the bits
> together, I won't believe the kernel support is anything other than
> 'experimental'.
>
> Other folk are actively advocating and exploring this model. For
> example, Chris Friedhoff has a page here that describes some first
> steps for using filesystem capabilities:
>
> ~  http://www.friedhoff.org/posixfilecaps.html

I already know and enjoy File system base capabilities thanks to Chris' 
website and Serge's developerWorks article.

What I meant to ask was what does "per-process securebits" brings as extra. 
FWIW in Pardus 2008 we'll enable Posix file capabilities by default so people 
could "harden" their setups.

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
