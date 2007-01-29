Return-Path: <linux-kernel-owner+w=401wt.eu-S964927AbXA2XZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbXA2XZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXA2XZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:25:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:1714 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894AbXA2XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IAHm00bx5tEcj3Eh+prTMRnXvLjOZCly7gBTPEbG9Eawy7zhICmm5ClV3rud8UjHEz9jIRcydm2e5Q3sygd0+ewfxNi68w7sutLZwnfi5d2YXMTGWU0RD+xV5hJvzaQqVbA8UH2St5hmeyjobadQa3LYWpO0QQOAIQkIiG50FgY=
Message-ID: <6bffcb0e0701291524l6ffa2ff8td232d6a28eb9d703@mail.gmail.com>
Date: Tue, 30 Jan 2007 00:24:59 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: script that import patches from local mm-commits mbox and adds them to local -mm tree
In-Reply-To: <45BDC927.3040804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45BDC927.3040804@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> http://www.stardust.webpages.pl/ltg/files/tools/witcher/witcher.py
>
> example series diff
> http://www.stardust.webpages.pl/ltg/files/tools/witcher/witcher-series
> (it's not perfect, but should work)

Now 'quilt fold' works fine.

Happy testing :)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
