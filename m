Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYD2Jfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYD2Jfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYD2Jf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:35:27 -0400
Received: from 1wt.eu ([62.212.114.60]:3515 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYD2Jf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:35:27 -0400
Date: Tue, 29 Apr 2008 11:34:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429093458.GA1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <20080429100107.79ebf0cc@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429100107.79ebf0cc@core>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:01:07AM +0100, Alan Cox wrote:
> > In fact, I would have better converted accentuated chars to their ASCII
> > equivalent to be more friendly with people who only read 7-bit.
> 
> Perhaps we should put them in latin as well just in case any Roman is
> struggling with this new language 8) Distibutions have been shipping UTF
> enabled by default for years and years.

"enabled" does not mean "working" Alan. I know one distro which I will
not name in order not to offense you which shipped with it enabled by
default, but which would not properly display the characters on the
console, resulting in mangled messages during boot. I particularly
remember the "[ECHEC]" ("[FAILED]") with random garbage instead of the
first 'E'.

:-)
Willy

