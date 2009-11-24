Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZKXJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZKXJJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbZKXJJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:09:52 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:47690 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbZKXJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:09:51 -0500
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091124175338.AFB6.A69D9226@jp.fujitsu.com>
References: <2f11576a0911031158r7fabb96fx8073bb4e86f4981e@mail.gmail.com>
	 <1258981499.11269.6.camel@holzheu-laptop>
	 <20091124175338.AFB6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 24 Nov 2009 10:09:55 +0100
Message-Id: <1259053795.4014.2.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 17:55 +0900, KOSAKI Motohiro wrote:
> > Hi,
> > 
> > I have several places in my code where the new __must_check of strstrip
> > will introduce unnecessary dummy variables to avoid the warnings.
> > 
> > Therefore I would like to have the suggested new strim() or
> > strstip_tail() function. Any chance to have this upstream soon?
> 
> strim() is in mmotm now. I expect it will merge mainline soon.

That's really good news!

Thanks!

Michael


