Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYGKIZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYGKIZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYGKIZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:25:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:12350 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYGKIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=if0VBhJ4e/eI2wiCzQ8l1T0+p780LYyMyKf1Eqtrj+bTvuuoba3E01PR7tylF8lL8G
         14mLV2Gm1rmcIxOWZDX9J894o2tqHxYhekMnAw427GKbjeA04vc6m5ptYB/yBVFrjI/g
         c18XAtPD0KEEFFNsZVnUlmXnXxYXZ5PAR2Zkw=
Message-ID: <84144f020807110125t667e2d2fi3b111c1127da3062@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:25:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 0/5] kmemtrace RFC patch series
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080710210543.1945415d@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710210543.1945415d@linux360.ro>
X-Google-Sender-Auth: 1b7467cda60130e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 10, 2008 at 9:05 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> I'd like to hear your opinion regarding kmemtrace and SL*B hooks.
>
> This is just a RFC, it's not intended to be merged yet. The userspace
> app is not included.

It would probably be helpful for anyone reviewing these patches to see
what the userspace program is doing. Can you please post an URL to a
tarball of the thing or its git repository?
