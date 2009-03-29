Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZC2H6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZC2H6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 03:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZC2H6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 03:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:59843 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZC2H6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 03:58:32 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49CEA3CD.105@kernel.org>
References: <1238251730.2526.2.camel@ht.satnam>
	 <20090328150746.GA3268@x200.localdomain>
	 <20090328190350.GA30214@uranus.ravnborg.org>  <49CEA3CD.105@kernel.org>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 13:27:30 +0530
Message-Id: <1238313450.3074.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 15:25 -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > 
> > Ordering include based on length of line minimize the
> > risk of merge conflicts.
> > If people just add new includes in the bottom of the list you
> > are certain that a merge conflit happens.
> > 
> > This scheme is starting to be used in several places with the
> > primary advocates being David Miller and Ingo.
> > 
> > It is getting used both for includes _and_ for local variables.
> > 
> 
> Personally I'd prefer alphabetic order, sorting based on length isn't a
> complete ordering.  Nearly all editors can sort alphabetically at the
> push of a key.
> 

This sorting is based on Length + alphabetic.

--
JSR

