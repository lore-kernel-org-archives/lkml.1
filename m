Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYDHTeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYDHTeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYDHTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:33:57 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:45084 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYDHTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iW9Li2I9YnhLw9nOdWjLqAbjwn0f0nrg1I6GapF8PLtNNojSVRKdeNZBwhlctINKEkEjtU3LMHvVvxonW9cJpetSUE1hSOGBR8m+/Vgvq/Mecp5VYYKKT/tBwnupGYZut9TX0KFfJAMMSl2h8749JQ5gMWZqmZnv14Y/dyyPZHc=
Message-ID: <36ca99e90804081233x2daef177u52a169d5382094df@mail.gmail.com>
Date: Tue, 8 Apr 2008 21:33:55 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080408184301.651388000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>
>   * Cleanup usages of cpumask_scprintf in the following files and add
>     another interface to use cpulist_scnprintf where appropriate.
Great. Sometimes the simplest solution needs the longest way. ;-)

Thanks.
Bert
