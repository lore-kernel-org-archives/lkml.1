Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXE0QIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXE0QIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXE0QIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:08:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:10464 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbXE0QIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=afSLevktnvGIR7vk99CgHWL2ZQgGHAOssBAhBEWn1puIUZBW2vL/hszzB4YeYfyeN99/KHbkLpHfOrQ5zOT3xcnOoJgd72nx3Ec52czNawbMdEpuZyue2RCm9HGmNlbBDw70khH0tv3UZH9pg0x4puPSgUtny1Adv/PDwIBJwPI=
Message-ID: <9a8748490705270908l8ecf621wfcd164f87fe5a22e@mail.gmail.com>
Date: Sun, 27 May 2007 18:08:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Auke Kok" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070525172515.5138.13652.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
	 <20070525172515.5138.13652.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/07, Auke Kok <auke-jan.h.kok@intel.com> wrote:
> Several standards have been established on how to format tests and use
> NULL/false/true tests.
>
Hmm, this may or may not be a good idea for CodingStyle, I'll leave
that up to others.
But, if you are going to renumber chapters then please also fix up the
references to those chapter numbers elsewhere in the file - like this
one

"... (for example as a means of replacing macros, see Chapter 12) ..."

After your patch that now points to the wrong chapter.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
