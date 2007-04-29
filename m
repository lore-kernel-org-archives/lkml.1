Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXD2MSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXD2MSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXD2MSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:18:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:61258 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXD2MSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c8MYRCuKDaBNwLa9TKWT/9FNqTsvOnhMKfmRM29dlDSAktY1dqLFRs2pWOBOKBeq/Xmm1wCDBy+qHK0NtoJ9+cV0u4Z0O4PJX5TI5Nlpkw6d9B1sFCOldD+fmTC6qecPL816AOlUVeTealBWxAtWc+TQQ4JwHnFDL05RJkcC4YE=
Subject: Re: [PATCH] [46/48] x86_64: adjust EDID retrieval
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070429105336.CF2E2151CB@wotan.suse.de>
References: <200704291252.514680000@suse.de>
	 <20070429105336.CF2E2151CB@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 20:18:26 +0800
Message-Id: <1177849106.17715.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 12:53 +0200, Andi Kleen wrote:
> From: "Jan Beulich" <jbeulich@novell.com>
> commit 5e518d7672dea4cd7c60871e40d0490c52f01d13 did the same change to
> i386's variant.
> 
> With this change, i386's and x86-64's versions are identical, raising
> the question whether the x86-64 one should go (just like there's only
> one instance of edd.S).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony

