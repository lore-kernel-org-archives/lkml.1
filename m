Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZIHCXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZIHCXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZIHCXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:23:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:38093 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZIHCXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=v+TRRqloZ5qu7hpPdsrm0u2fLzqhIq9vwkWvsipnWLnXGYu4sng3CST8GYjsfqaT2Q
         3km7kIHp1MR0dOBEcn5TA0hJG+o1XqEHnk1iFCQ5k8KxDE86PhNFjnnpTOdGlR+YT5Qt
         zTB3we8UxOQdE8f7PFf1DqMHn26BIdInrc5/w=
MIME-Version: 1.0
In-Reply-To: <df9815e70908270145q381ce8acxa3770480431ac526@mail.gmail.com>
References: <df9815e70908270145q381ce8acxa3770480431ac526@mail.gmail.com>
Date: Tue, 8 Sep 2009 10:23:54 +0800
Message-ID: <df9815e70909071923l22eff525h9706d654f8b41572@mail.gmail.com>
Subject: Re: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
From: Jike Song <albcamus@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 4:45 PM, Jike Song<albcamus@gmail.com> wrote:
> hi, I hit this with vnc. Below is part of dmesg :

Still producible in 2.6.31-rc9, anybody helps?


-- 
Thanks,
Jike
