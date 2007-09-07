Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXIGNM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXIGNM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXIGNMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:12:48 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:48264 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbXIGNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGfA2pt5DAAbCavVzx16u40sd29RV6dnUGa4gWGmDvKScm3K5pj5c9tsFNiq6MkcbcKtWVyWw1Z1aCaqb3M2lB+w+3+OVIIPxMvQF96gx6PdVx/AgTo/kjuS2M3AwigX5V8Vi8CCs2HYzgmMbA5BVtJX05qMzTEtdlVrGQK7tU0=
Message-ID: <b6fcc0a0709070612t3d80ff6k982740cffe3abff1@mail.gmail.com>
Date: Fri, 7 Sep 2007 17:12:46 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: EIP: [<c02d0069>] tcp_rto_min+0x8/0x12 SS:ESP 0068:c03bbd6c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV19AEEDC8DA30835B958052B2C50@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV19AEEDC8DA30835B958052B2C50@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> Linux 2.6.23-rc5 after 30 minutes crash with this
> error message (taken from serial console):

> EIP is at tcp_rto_min+0x8/0x12

get 2.6.23-rc5-git1, fix is in it.
http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.23-rc5-git1.bz2
