Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYELKjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYELKjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbYELKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:38:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYELKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RvDqiY0gpA+CSdtCHHjWKx4pFZdLMz1lUVL0omHnFXgnAXMapAPTKsLMto7GFWBcvly23hqqbW9AnHMZdJMvVdT1F6haq+/jdsIxtFLigDqhD55PCHyKf6lvJVzHDtd/qxnmh9sOOiygccAxM3wLI7uYR523rb9JVJ+lGaOHbbU=
Message-ID: <8bd0f97a0805120338l1d7e0e7eiffebae3bf33c172c@mail.gmail.com>
Date: Mon, 12 May 2008 06:38:55 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 4/4] [MM/NOMMU]: Export two symbols in nommu.c for mmap test
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org,
       "Vivi Li" <vivi.li@analog.com>
In-Reply-To: <1210588325-11027-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-5-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 6:32 AM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Vivi Li <vivi.li@analog.com>
>
> http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2312

i dont think URLs to our tracker is a good substitute for log
messages.  our tracker URLs have known to break in the past (due to
gforge changes), and it's a pain for people reading changelogs to open
up a browser just to see what the issue is about.
-mike
