Return-Path: <linux-kernel-owner+w=401wt.eu-S1761111AbZC1W0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761111AbZC1W0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZC1W0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:26:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZC1W0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:26:40 -0400
Message-ID: <49CEA3CD.105@kernel.org>
Date: Sat, 28 Mar 2009 15:25:17 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org>
In-Reply-To: <20090328190350.GA30214@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> Ordering include based on length of line minimize the
> risk of merge conflicts.
> If people just add new includes in the bottom of the list you
> are certain that a merge conflit happens.
> 
> This scheme is starting to be used in several places with the
> primary advocates being David Miller and Ingo.
> 
> It is getting used both for includes _and_ for local variables.
> 

Personally I'd prefer alphabetic order, sorting based on length isn't a
complete ordering.  Nearly all editors can sort alphabetically at the
push of a key.

	-hpa
