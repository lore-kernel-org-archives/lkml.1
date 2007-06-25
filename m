Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbXFYCP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbXFYCP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXFYCPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:15:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:40782 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXFYCPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fYhc8Wy0Kp0PDBRdouqpkFf4zroP9AH5yyKZKg/v0nByBcITs7/IbFN9wHegJ8imxLLdVqVt3M7YWYdWgMiF/OUnT+ca+RvlQqWxfWdOU+S+iPaZB5qgv2E0XBtgZ76E4FoND4o8N1jyk71pTp2L+2I+DVIjfnAbAdAmxWQy8PE=
Message-ID: <467F252A.5070607@gmail.com>
Date: Mon, 25 Jun 2007 11:15:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: enricoss@tiscali.it, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: hsm violation
References: <467E6456.4030503@tiscali.it> <20070624123022.541f2f78.akpm@linux-foundation.org>
In-Reply-To: <20070624123022.541f2f78.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> That great spew of "set_level status: 0" is fairly annoying and useless.

I don't know where those are coming from.  It's not from libata.

-- 
tejun
