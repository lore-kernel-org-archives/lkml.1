Return-Path: <linux-kernel-owner+w=401wt.eu-S1030817AbXCTAoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817AbXCTAoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXCTAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:44:15 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:58778 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030817AbXCTAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:44:14 -0400
Date: Tue, 20 Mar 2007 01:40:01 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Message-ID: <20070320004001.GA11601@electric-eye.fr.zoreil.com>
References: <45FEB8B7.7020200@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FEB8B7.7020200@sciensis.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tasos Parisinos <t.parisinos@sciensis.com> :
[...]

RSA is slow. syscalls are fast.

Which part of the kernel is supposed to benefit from this code ?

-- 
Ueimor
