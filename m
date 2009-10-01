Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZJARuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZJARuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZJARuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:50:06 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22464 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZJARuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:50:05 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Date: Thu, 1 Oct 2009 17:49:15 +0000
Subject: RE: [PATCH 07/34] move ilo_remove to .devexit.text
Thread-Topic: [PATCH 07/34] move ilo_remove to .devexit.text
Thread-Index: AcpCvuFti2+pwZJsQYKthP3CCsL+FwAAHbRg
Message-ID: <92D64232F2316045B18937D5C9996B1522CD82E201@GVW1144EXB.americas.hpqcorp.net>
References: <20091001082607.GA2181@pengutronix.de>
 <1254385718-14254-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <92D64232F2316045B18937D5C9996B1522CD82DF6E@GVW1144EXB.americas.hpqcorp.net>
 <20091001174449.GB27288@pengutronix.de>
In-Reply-To: <20091001174449.GB27288@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Looks good to me.  Not sure if this is needed or not...
> it fixes at least a warning 

Sorry for any confusion, I was referring to my specific Acked-by, 
I didn't know if you needed that from me.
