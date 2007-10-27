Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbXJ0W0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbXJ0W0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 18:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXJ0W0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 18:26:47 -0400
Received: from ozlabs.org ([203.10.76.45]:39635 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXJ0W0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 18:26:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] select PARAVIRT when PARAVIRT_GUEST on
Date: Sun, 28 Oct 2007 08:27:02 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, ak@suse.de, zach@vmware.com, jeremy@goop.org,
       chrisw@sous-sol.org, akpm@linux-foundation.org
References: <11934940321103-git-send-email-gcosta@redhat.com>
In-Reply-To: <11934940321103-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710280927.03400.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2007 00:07:12 Glauber de Oliveira Costa wrote:
> Commit d3d1c4bdf16bd154d9f27f34fca28edca90465eb introduces a new config
> knob that, according to its changelog, should select CONFIG_PARAVIRT.

Hi Glauber,

	PARAVIRT is now selected by the options which need it.  Merely turning on the 
menu "does not add any kernel code" as promised in the text...

Rusty.
