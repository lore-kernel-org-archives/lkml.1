Return-Path: <linux-kernel-owner+w=401wt.eu-S939746AbXG3X4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939746AbXG3X4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763101AbXG3Xzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:55:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12783 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763715AbXG3Xzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=glfIbfNf8ud9SvzbzyJd5pKZ0eHw8asqoe2hKNZSfNB37vVsdBkHQAWues2G+Ch79t2ZiVduoO175BUSD+gBi4WnWxL0nH8L1FmAIf6f3R7XcUukv5nw21+KJ8TZlKdqRhLq4m5u4RM5KEZRBg9Qrmj+uRwfXVUTuN5eWMCsd+U=
Subject: Re: [PATCH] Framebuffer: Consolidated cleanup of pvr2fb.c for Sega
	Dreamcast
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
In-Reply-To: <20070730194854.GA29181@linux-sh.org>
References: <8b67d60707281739l6fc544e9k5eb130ab6e426ad2@mail.gmail.com>
	 <20070730194854.GA29181@linux-sh.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 07:55:24 +0800
Message-Id: <1185839724.9324.19.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 04:48 +0900, Paul Mundt wrote:
> On Sun, Jul 29, 2007 at 01:39:51AM +0100, Adrian McMenamin wrote:

> This looks fine to me in any event. I can either wrap this up in my tree
> or Tony can include it with his next set of updates if he has any other
> concerns. Thanks, Adrian.
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>

I'll do the merge and push to mainline. This patch is really composed of
three changes (one is already in mainline, the second is a resource
allocation clean-up, and the third is Adrian's change).

Tony

