Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbXHAH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbXHAH65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXHAH6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:58:49 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:20090 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbXHAH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R1TUxL2JsveJ5wOytTxw9dYVTQekwRKGLpkddo7wPkIRNhq3xwnMh3H7rixY+oF6mwefDekejXO7TZa0Zo1pMjABzcnk/cQS5CwImULdffCn64cC/JePJpCEKip1hGDpLr3TpK3TywmyCjgw9QwiwdTRfih1JDI8ax2NzhrrTIM=
Message-ID: <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
Date: Wed, 1 Aug 2007 03:58:48 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
In-Reply-To: <20070801062501.GB7581@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <20070801062501.GB7581@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
> > - Is anyone testing the kgdb code in here?
>
> Testing, yes. Succeeding, no. It's utterly hosed on SH in its present
> condition at least. Presumably it's been tested on at least one platform
> with some measure of success, but it's certainly not mine ;-)

does kgdb actually have a chance to get merged ?  with the history of
it, i just assumed it was never going in, so we've been using our own
kgdb patch on Blackfin ... so the version *we have* works great :) but
if there's a chance of this actually going mainline, we can see about
testing that version as well ...
-mike
