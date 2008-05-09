Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbYEINH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbYEINH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYEINHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:07:49 -0400
Received: from mail.lysator.liu.se ([130.236.254.3]:33933 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYEINHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:07:48 -0400
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 09:07:48 EDT
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org>
	<20080429050605.GA27875@1wt.eu>
From: =?utf-8?Q?David_K=C3=A5gedal?= <davidk@lysator.liu.se>
Date: Fri, 09 May 2008 14:48:37 +0200
In-Reply-To: <20080429050605.GA27875@1wt.eu> (Willy Tarreau's message of "Tue\, 29 Apr 2008 07\:06\:05 +0200")
Message-ID: <8763tn3aoq.fsf@lysator.liu.se>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> And do we really consider that people's names in *comments* cannot
> be converted to pure ASCII ? I'm western european and have always
> been against accents in comments (another reason to write comments
> in english BTW). Unix and internet have lived without accents for
> almost 30 years without anyone really bothering. 

That's a ridiculous statement.  Just because you didn't bother, you
can't assume that the people who were actually affected didn't bother.

I went through large parts of the 1990's under the name "David
K}gedal". And I bothered.

And no, the second character in my last name is not an accented a,
they have been separate letters for hundreds of years in Sweden.  So I
can live without using accented letters, as long as I can write
Kågedal including the å. :-)

Not that my name appears anywhere in the Linux source, but I still
felt the urge to reply...

-- 
David Kågedal
