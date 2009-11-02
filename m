Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZKBQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZKBQlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZKBQlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:41:14 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58841 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZKBQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:41:14 -0500
MIME-Version: 1.0
In-Reply-To: <4AEF086D.9010600@austin.ibm.com>
References: <4AE8ADCF.6090104@austin.ibm.com> <4AE8AF4D.4030403@austin.ibm.com> 
	<1256785731.26770.38.camel@pasglop> <4AEF086D.9010600@austin.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 2 Nov 2009 09:40:59 -0700
X-Google-Sender-Auth: aa9547c1c4e44a1f
Message-ID: <fa686aa40911020840s3a6a4819g85f3be3a305820bf@mail.gmail.com>
Subject: Re: [PATCH 1/6 v5] Kernel DLPAR Infrastructure
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 9:27 AM, Nathan Fontenot <nfont@austin.ibm.com> wrote:
> I saw that Grant Likely is doing updates to all of the of_* stuff right now,
> would it be ok to have these routines here, renamed as dlpar_*, and look
> to merge them in with Grant's updates when he finishes?

No because then we're stuck with renaming the API at a later date.
Name it what it is, and put it where it belongs.  I'll deal with any
merge breakage as it occurs.

g.
