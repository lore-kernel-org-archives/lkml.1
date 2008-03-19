Return-Path: <linux-kernel-owner+w=401wt.eu-S1762424AbYCSUvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbYCSUvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbYCSTqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:46:10 -0400
Received: from saeurebad.de ([85.214.36.134]:33966 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbYCSTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:46:09 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: rossb@google.com (Ross Biro)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 2/2]: MM: Make Page Tables Relocatable
References: <20080319142016.E048DDC98D@localhost>
Date: Wed, 19 Mar 2008 15:56:13 +0100
In-Reply-To: <20080319142016.E048DDC98D@localhost> (Ross Biro's message of
	"Wed, 19 Mar 2008 07:20:16 -0700 (PDT)")
Message-ID: <87r6e6oj8y.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

rossb@google.com (Ross Biro) writes:

> diff -uprwNbB -X 2.6.23/Documentation/dontdiff 2.6.23/include/linux/#gfp.h# 2.6.23a/include/linux/#gfp.h#
> --- 2.6.23/include/linux/#gfp.h#	1969-12-31 16:00:00.000000000 -0800
> +++ 2.6.23a/include/linux/#gfp.h#	2008-01-30 07:39:06.000000000 -0800
> @@ -0,0 +1,198 @@
> +#ifndef __LINUX_GFP_H
> +#define __LINUX_GFP_H

I suppose you use Emacs?

	Hannes
