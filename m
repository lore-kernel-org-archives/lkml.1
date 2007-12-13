Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbXLMB1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbXLMB1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 20:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXLMB1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 20:27:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:12383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbXLMB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 20:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wdNGjKWd9iEsUhnOB7BLGAvD2Kc9/pvpiWWaRqD8i5VUwc3+uM6+1ZbDe1Ntxk9W78+pX67G0YZa0SXUoDTSMsoS49RP9dRz+kNWNzZMG0nemprndwllrvoLOXetTHzEje585GaZFDFBtcLP56GmN9hCoAZMTvzhI94q9aT6GiA=
Message-ID: <a8e1da0712121727m143fd036wd4762c1562b6dc24@mail.gmail.com>
Date: Thu, 13 Dec 2007 09:27:03 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Michal Schmidt" <mschmidt@redhat.com>
Subject: Re: kernel panic - help!?
Cc: "Justin Banks" <justinb@bakbone.com>,
       "Oliver Falk" <oliver@linux-kernel.at>, linux-kernel@vger.kernel.org
In-Reply-To: <20071212173753.5bf5bb5b@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475FA716.2000105@linux-kernel.at>
	 <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>
	 <20071212142436.GB16664@bleen.domain.actdsltmp>
	 <20071212173753.5bf5bb5b@brian.englab.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 12:37 AM, Michal Schmidt <mschmidt@redhat.com> wrote:
> On Wed, 12 Dec 2007 07:24:36 -0700
> Justin Banks <justinb@bakbone.com> wrote:
>
> > > > (2.6.9-55.0.9.ELsmp)
> > -----^^^^^^^^^^^^^^^^^^

I'm so blind.

> >
> > It's really really old :)
>
> No, it's actually less than 3 months old kernel from RHEL-4 or CentOS.

Maybe, but the version number is old indeed.

BTW, Oliver Falk , the problem seems caused by sysfs readdir, it  was
probably fixed already.  Please try latest kernel.

Regards
dave
