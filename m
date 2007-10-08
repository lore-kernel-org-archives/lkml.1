Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXJHTrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXJHTrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbXJHTrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:47:07 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:57496 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXJHTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:47:06 -0400
Date: Mon, 8 Oct 2007 21:47:04 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: regression in 2.6.23-rc8 - power off failed: solved
Message-ID: <20071008194704.GA26337@erig.dyndns.org>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org> <20070929180721.GA8371@erig.dyndns.org> <46FED429.9050200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FED429.9050200@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 11:48:40AM -0700, H. Peter Anvin wrote:
>
> Does your .config file have CONFIG_APM=y?  Otherwise, that's your problem 
> right there (since your old laptop doesn't appear to have ACPI.)

no CONFIG_APM and yes, this is my problem.
A very hard way to figure this out,
and too much noise. Sorry for this.

It is not the first time, I had to change my .config to maintain a
feature of the kernel after an upgrade. I think, you are aware of this
an I have no suggestion for improvement. Now this old laptop is
running perfectly again with the latest kernel.

Thankyou for this,
Wolfgang
