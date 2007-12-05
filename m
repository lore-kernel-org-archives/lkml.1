Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbXLECGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbXLECGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 21:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLECGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 21:06:05 -0500
Received: from ozlabs.org ([203.10.76.45]:48184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLECGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 21:06:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Date: Wed, 5 Dec 2007 13:05:48 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
References: <4755BA14.8060706@grupopie.com>
In-Reply-To: <4755BA14.8060706@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712051305.48951.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 07:35:32 Paulo Marques wrote:
> When resolving symbol names from addresses with aliased symbol names,
> kallsyms_lookup always returns the first symbol, even if it is a weak
> symbol.

Thanks, this looks great.

Rusty.
