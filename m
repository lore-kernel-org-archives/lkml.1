Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZD0Sqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZD0Sqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZD0SqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:46:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53047 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbZD0SqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:46:03 -0400
Date: Mon, 27 Apr 2009 20:49:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "willy@linux.intel.com" <willy@linux.intel.com>, rjw@sisk.pl
Subject: Re: Discrepancies between Oprofile and vmstat
Message-ID: <20090427184958.GF27382@one.firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> <87ljpmk29b.fsf@basil.nowhere.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 11:38:08AM -0700, Styner, Douglas W wrote:
> We are using an OLTP-type workload on a fully saturated system and have begun seeing a discrepancy between the output of oprofile and vmstat on upstream kernels that was first seen with the 2.6.27 kernel.

Rafael,

something to track for the regression list.

-Andi

