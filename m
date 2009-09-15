Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZIOGfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZIOGfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZIOGfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:35:00 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:39144 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZIOGe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BrvbBCt8s51oym3ZXyoA7rwGefvA0k1ZkgF7PzZiGKvZ1cb+iJ/9E91YOH9y5p+GSe
         CtG68YwTOls/TsB6vbVCsDna3KgWck2nYrWqi152bNIYYhs/cViYgf1VM3kxDT71Lw51
         Fp+23e3MnRRD+DDF2q86RgqeEKu3lMYvY9bd4=
Date: Mon, 14 Sep 2009 23:34:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Suresh Jayaram <sureshjayaram@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
Message-ID: <20090915063458.GC10232@core.coreip.homeip.net>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org> <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com> <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Sep 14, 2009 at 09:59:12PM -0700, David Rientjes wrote:
>
> The second is an issue with the i8042 driver's laptop table not being NULL 
> terminated.  This is fixed by Jin Dongming's patch at
> http://marc.info/?l=linux-kernel&m=125263897713267.
> 

Should be good in my tree/next/mainline now.

-- 
Dmitry
