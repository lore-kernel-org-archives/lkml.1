Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZD0WgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZD0WgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbZD0Wf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:35:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:19350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097AbZD0Wf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,256,1239001200"; 
   d="scan'208";a="136529912"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Date: Mon, 27 Apr 2009 15:35:57 -0700
Subject: RE: Discrepancies between Oprofile and vmstat II
Thread-Topic: Discrepancies between Oprofile and vmstat II
Thread-Index: AcnHhiogPJH+oCkFS0OQA5HRUsTLDQAAc9TQ
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345987850@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
 <87ljpmk29b.fsf@basil.nowhere.org>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
 <20090427185305.GG27382@one.firstfloor.org>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459877BD@azsmsx501.amr.corp.intel.com>
 <20090427222242.GJ27382@one.firstfloor.org>
In-Reply-To: <20090427222242.GJ27382@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>You mean "with higher value", right ?

Right.  Higher number of samples; lower count value.  I'm going to try it the other way as well (count value = 200000)

>
>It's still strange that it suddenly changed in 2.6.27 though. There
>shouldn't have been
>a difference there. So I still think it's a regression.
>

We only first saw it in 2.6.27.  It is possible that it goes back to 2.6.26 or 2.6.25.  We have not confirmed those kernels.

