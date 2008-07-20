Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYGTKia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYGTKia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYGTKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:38:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:7519 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbYGTKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ancReuVt2qExzpX6SF1wVOUvJ7Ke4NE3KyksDmVHS/heqKt0qoWreek8aSYD/CWjZ6
         3SFi7cyxTswaxIt11i79ZVWKARImTEOY/Zn/BhCrvfawqQtALmETym3HtgbeOQrquzOi
         rZJn5Pse2ehdB65jP+XJ6DjQp1/+KacQLwYYg=
Message-ID: <84144f020807200338s55074230he16cc3dda3b012e6@mail.gmail.com>
Date: Sun, 20 Jul 2008 13:38:19 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] slub: Add defrag_ratio field and sysfs support.
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, riel@redhat.com
In-Reply-To: <20080719105239.4a89f64c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>
	 <20080719105239.4a89f64c.akpm@linux-foundation.org>
X-Google-Sender-Auth: fd158c25a86ce7fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, Jul 19, 2008 at 8:52 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Were you planning on sending out the patches to wire all this up
> to the notorious caches?

No, I wasn't because don't have those patches in my tree (and I
probably don't want them either). Christoph?
