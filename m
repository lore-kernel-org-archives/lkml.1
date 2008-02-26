Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbYBZN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbYBZN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYBZN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:56:31 -0500
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:62802 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753095AbYBZN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:56:31 -0500
Message-ID: <47C41A1D.6010409@plouf.fr.eu.org>
Date: Tue, 26 Feb 2008 14:54:37 +0100
From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Organization: Plouf !
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: fr,en
MIME-Version: 1.0
To: dann frazier <dannf@dannf.org>
CC: Willy Tarreau <w@1wt.eu>, Glen Nakamura <glen@imodulo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.4.36.1 hangs.
References: <20080223083044.GA24136@1wt.eu> <20080226073612.GA29747@modulo.internal> <20080226081624.GA20022@1wt.eu> <20080226101346.GB20166@colo.lackof.org>
In-Reply-To: <20080226101346.GB20166@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dann frazier a écrit :
> 
> Correcting the le16_to_cpu placement as Glen described
> fixes the issue for me.

One of my boxes has at least six directories triggering the issue (I 
must be very unlucky), and Glen's patch fixes it all. Thanks.
