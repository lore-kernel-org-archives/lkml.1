Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYDKTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYDKTW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbYDKTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:22:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56498 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbYDKTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:22:43 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, trond.myklebust@fys.uio.no, eshel@almaden.ibm.com,
       neilb@suse.de, akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080411191910.GB16965@fieldses.org> (bfields@fieldses.org)
Subject: Re: nfs: infinite loop in fcntl(F_SETLKW)
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu> <E1Jk2oI-0007UX-MS@pomaz-ex.szeredi.hu> <1207861339.8180.14.camel@heimdal.trondhjem.org> <1207861661.8180.18.camel@heimdal.trondhjem.org> <1207862436.8180.30.camel@heimdal.trondhjem.org> <20080410215410.GF22324@fieldses.org> <E1JkOff-0000pS-A7@pomaz-ex.szeredi.hu> <20080411191910.GB16965@fieldses.org>
Message-Id: <E1JkOpU-0000rX-6L@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 11 Apr 2008 21:22:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Btw, why hasn't this work been posted on -fsdevel prior to merging
> > into mainline?
> 
> http://marc.info/?l=linux-fsdevel&m=117581629326194&w=2

Ah, sorry.  I was only looking at the last half year of archives :)

Miklos
