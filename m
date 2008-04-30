Return-Path: <linux-kernel-owner+w=401wt.eu-S1765104AbYD3Tns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765104AbYD3Tns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762582AbYD3Tnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:43:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760335AbYD3Tnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:43:39 -0400
Message-ID: <4818CBB7.9070401@kernel.org>
Date: Wed, 30 Apr 2008 12:42:47 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <481838A0.2060507@aitel.hist.no>
In-Reply-To: <481838A0.2060507@aitel.hist.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:
> It would not surprise me if some distros  botch utf-8 through negligence.
> They are based in english-speaking countries and have their biggest
> user bases there - the majority of their customers aren't going to use 
> more than ascii so why should they bother.

Well, we were talking about Mandriva, which is a Brazilian-French 
company, their main languages are Portugese and French; you'd think 
they'd notice themselves.  Most likely there was something in Willy's 
configuration that buggered it up.

	-hpa

