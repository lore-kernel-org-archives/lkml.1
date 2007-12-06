Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXLFXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXLFXrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXLFXro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:47:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:4391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXLFXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tZThR3O0+8+jPDTiSHBLCGQhR2PPIrHf/jrlojS5QvE26EjnhthspjxmtmGCSfM06EYWOCPYQu3KB2Jkg5gRMuuWCczizTfYkqSHZ0up5TnEotv2Guu4dSm7XwUi7bA5La35VE7piecL3tlXfWZP5ZzhBpBW1TnjjGUXnVMzgx8=
Message-ID: <a44ae5cd0712061547l73abdf0blbd0286b410bd677d@mail.gmail.com>
Date: Thu, 6 Dec 2007 18:47:43 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1: VDSOSYM build error
Cc: laurent.riffard@free.fr, linux-kernel@vger.kernel.org, roland@redhat.com,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20071206153415.353ddeea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <47587796.8020705@free.fr>
	 <20071206143754.07a67819.akpm@linux-foundation.org>
	 <a44ae5cd0712061528j4c0ea529w71bd2b96e1e73043@mail.gmail.com>
	 <20071206153415.353ddeea.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found:
http://marc.info/?l=linux-kernel&m=119550978915647&w=2
through
http://marc.info/?l=linux-kernel&m=119551057816829&w=2
(I was unable to locate the 6th patch in the set)

When I tried backing out the patches, there were tons of errors.  I
guess I'll punt on trying to build this MM tree.  Sorry.

         Miles
