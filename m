Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbZLOO5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbZLOO5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760472AbZLOO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:57:39 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:42934 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbZLOO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:57:38 -0500
Date: Tue, 15 Dec 2009 07:57:37 -0700
From: Alex Chiang <achiang@hp.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, rjw@sisk.pl,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: radeon 4830 corruption after resume
Message-ID: <20091215145737.GA8209@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com> <1260759123.3391.0.camel@localhost> <20091214031127.GB29591@ldl.fc.hp.com> <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com> <20091215054004.GF587@ldl.fc.hp.com> <a728f9f90912150652p7fc1c2d8tc341e4c6f59e5346@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a728f9f90912150652p7fc1c2d8tc341e4c6f59e5346@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Deucher <alexdeucher@gmail.com>:
> 
> As Dave asked previously, is this a regression?  I.e., did s/r work at
> some point in the past and if so when?

I'm not sure, as I just received the machine a few days ago.

I can try some older kernels, but part of my issue is not knowing
how all the pieces fit together. How can I tell if I'm supposed
to be bisecting the kernel or X or something else, given my
symptoms?

Thanks,
/ac

