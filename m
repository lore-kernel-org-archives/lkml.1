Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXK0FU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXK0FU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXK0FUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:20:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:19295 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXK0FUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pa0ivcXTovDds4DGEYeN3svxa/5h4HmDTuzKKR87wBrl2lnYpowjucGWEKVbvVTl2RLgDbvB1P+fjJtCGAhjRuU/cz4NOqxLjbG0sqnhkJj38CKvaW5tgEkWGjTKBNTYpS/Am0tEwF8xdvie9jku9QjhzSiklfHonjd83gqlTbE=
Message-ID: <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com>
Date: Mon, 26 Nov 2007 22:20:12 -0700
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <20071127001430.083503280@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071127001407.859743255@sgi.com>
	 <20071127001430.083503280@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/07, Christoph Lameter <clameter@sgi.com> wrote:
> The model(small) attribute is not supported by gcc 4.X. The tests
> will always be negative today.

What was the rationale for removing this attribute?

  --david
