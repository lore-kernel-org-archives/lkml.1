Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYG0N7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYG0N7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYG0N7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:59:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:15533 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYG0N7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rcsI1qoNuB7F1ahu8tWAWVaDQvSGnCoJfrMgTjpLZxhSOX2mlko42SxcgvjM6aNLEs
         DR1GwtpGauRDH50pwM9bVM+wglk9yIiJQWAwZZm1RTvEp25dS9N8wUE39coNuseM8RUQ
         JNoCYo7GF323NGdGL0mju5ncDEaaDbKTJgL5s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: recent IDE regression
Date: Sun, 27 Jul 2008 15:48:41 +0200
User-Agent: KMail/1.9.9
Cc: harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20080724.233831.193691312.davem@davemloft.net> <200807261404.49947.bzolnier@gmail.com> <20080726.173143.137065135.davem@davemloft.net>
In-Reply-To: <20080726.173143.137065135.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807271548.44391.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 July 2008, David Miller wrote:

[...]

> Therefore I would suggest not adding changes during the merge window
> that you or someone else has not actually tested.

This the standard policy, unfortunately having 100% testing
coverage is not possible without active help from other people.

Anyway, I'll try to make stricter selection next time.

Thanks,
Bart
