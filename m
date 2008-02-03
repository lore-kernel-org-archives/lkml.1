Return-Path: <linux-kernel-owner+w=401wt.eu-S936168AbYBCGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936168AbYBCGZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbYBCGZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:25:23 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:60263 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759562AbYBCGZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:25:22 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] per-process securebits
Date: Sun, 3 Feb 2008 08:25:48 +0200
User-Agent: KMail/1.9.8
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
References: <47A2D439.9050704@kernel.org> <47A558CF.60702@kernel.org> <20080202221812.2f9d70a8.akpm@linux-foundation.org>
In-Reply-To: <20080202221812.2f9d70a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802030825.49221.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Sunday 03 February 2008 around 08:18:12 Andrew Morton wrote:
> So how do we ever get to the stage where we can recommend that distributors
> turn these things on, and have them agree with us?

FWIW with my distributor hat on I think File system capabilities are very nice 
and enables one to ship a distribution with a small set of setuid binaries.

On the other hand for per-process securebits, it would be nice to see a 
complete example how it could be applied to a setuid program. That would be a 
nice step in moving forward.

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
