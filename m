Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbZDAW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbZDAW7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932957AbZDAW7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:59:19 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48987 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbZDAW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:59:18 -0400
Date: Wed, 1 Apr 2009 18:59:16 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090401225916.GZ3795@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net> <20090401165741.GA3797@csclub.uwaterloo.ca> <20090401190340.GA29673@uranus.ravnborg.org> <20090401194810.GY3795@csclub.uwaterloo.ca> <10f740e80904011323t219063b0ife4db1677ca0d22b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e80904011323t219063b0ife4db1677ca0d22b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 10:23:06PM +0200, Geert Uytterhoeven wrote:
> It entered mainline just before v2.6.29 (after v2.6.29-rc8)?
> Or did you find a new problem?

No, I just didn't check yet.  I am still solving uclibc issues, so
2.6.29-rc3 was still doing the job.

-- 
Len Sorensen
