Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXCLSrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXCLSrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXCLSrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:47:16 -0400
Received: from paf87.warszawa.sdi.tpnet.pl ([217.96.225.87]:31364 "EHLO
	qrnik.knm.org.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXCLSrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:47:15 -0400
Subject: Re: _proxy_pda still makes linking modules fail
From: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
To: linux-kernel@vger.kernel.org
In-Reply-To: <p73lki39s3a.fsf@bingen.suse.de>
References: <1173315479.12472.9.camel@qrnik>
	 <p73lki39s3a.fsf@bingen.suse.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Mar 2007 19:47:06 +0100
Message-Id: <1173725227.32613.0.camel@qrnik>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 PLD Linux 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 12-03-2007, pon o godzinie 02:19 +0100, Andi Kleen napisał(a):

> Hmm, it probably needs a EXPORT_SYMBOL. The previous change only
> fixed the in kernel build.
> 
> Does it work with this patch?

Yes! Thank you.

-- 
   __("<         Marcin Kowalczyk
   \__/       qrczak@knm.org.pl
    ^^     http://qrnik.knm.org.pl/~qrczak/

