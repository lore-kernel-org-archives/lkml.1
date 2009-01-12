Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZALVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZALVJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZALVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:09:33 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:65295 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZALVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XnZumbxwpYxBMJZrlqhricYXfcHd6M9w9dPnfOaS+gX8omMUiyl4hkGhnsKNX7rQfQ
         yiflidWHp5R421rcvGV/F2ORYIs/vvgsWq0yC2M2wFOrEFzigwkylghBPGxU6VYU8SJ4
         f7CA9IHJGGQhoK9TWOi4/Qme9dTyq3mQ6Y03U=
Subject: Re: - lis3lv02d-separate-the-core-from-hp-acpi-api.patch removed
 from -mm tree
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, eric.piel@tremplin-utc.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090112124947.79b7b74d.akpm@linux-foundation.org>
References: <200901121958.n0CJw9ke027350@imap1.linux-foundation.org>
	 <20090112203044.GE2299@elf.ucw.cz>
	 <20090112124947.79b7b74d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 13:09:14 -0800
Message-Id: <1231794554.5405.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 12:49 -0800, Andrew Morton wrote:
> On Mon, 12 Jan 2009 21:30:44 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > BTW... "-" for both "patch is junk" and "patch is now mainline" is quite
> > confusing. Could we get you to use "-" for "patch was dropped because
> > it is junk" and "*" (or something) for "patch is now mainline"?
> 
> I think I can manage that.

maybe:

-[short reason]patchname.patch

Examples
-[upstream]patchname.patch for mainline or subsytem tree
-[junk]patchname.patch
-[update]patchname.patch for 'updated version will be merged'

Or, if you started to track how things got upstream, then you could easily
let people know where to go looking for it.

-[mainline]
-[x86]
-[gregkh]

Just a thought.

Harvey

