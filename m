Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYCZRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYCZRow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYCZRon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:44:43 -0400
Received: from bender.weihenstephan.org ([62.245.246.226]:41141 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYCZRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:44:42 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Date: Wed, 26 Mar 2008 18:44:37 +0100
User-Agent: KMail/1.9.4
Cc: Dmitry <dbaryshkov@gmail.com>
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com> <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
In-Reply-To: <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261844.37739.juergen127@kreuzholzen.de>
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 17:52, Dmitry wrote:
>[...]
> >
> > Hmm...this is exactly twice as big as the struct I'm currently using,
> >  it doesn't contain all the fields I need, and it's undocumented.
>
> I've added a more sofisticated arch convertion patch (the clocklib for
> ARM PXA chips).
>
> Basically mode becomes enable/disable (however it may be better to merge
> back those pointers into one function). And dev and index go to priv data.
>
> The documentation will come later.
                              ^^^^^
Most of the time this means "never".

JB
