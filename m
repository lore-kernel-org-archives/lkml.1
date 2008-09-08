Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYIHSFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYIHSFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYIHSE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:04:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:5041 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbYIHSE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uTvBlJHEDlPzsr5tAKrAB5yzuqQhOVH/LNqRVKbjxXtiHu9ZBcq7EIcb4joq2u0EUz
         vRnccVmMwkojAl3QDf68RYhEYIAzfTBtCkrLrPK2BxXWPDxKjyBjUecdRhanEvybQ++C
         5J8BcrsQVAgark+UdndHS56xIa1jFS8P9aOkA=
Message-ID: <86802c440809081104i23b477e1w62bd5967b79529cb@mail.gmail.com>
Date: Mon, 8 Sep 2008 11:04:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
	 <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 10:54 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:

can you post boot log with working kernel + "debug"?

YH
