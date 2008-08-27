Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYH0XiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYH0XiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYH0Xhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:37:55 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:58601 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754331AbYH0Xhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:37:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rfw90fHuzcjw2WoyY/uu9lBD5bhOjdDjq5wfUGjH9w/CfJxAAyUba00U+d5mSRnlfHDpf4Q4hY2YR9ujyNEtqAbhiPh5ctXyt/0OHQLndXLi+n5XlrzaY/IQGwU7YIR7;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] PCI: Document that most pci options are shared between i386 and x86-64
Date: Wed, 27 Aug 2008 16:37:51 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080822075339.GA2167@basil.nowhere.org>
In-Reply-To: <20080822075339.GA2167@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271637.52341.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2008 12:53 am Andi Kleen wrote:
> PCI: Document that most pci options are shared between i386 and x86-64
>
> Since the code is shared pretty much most of the pci= options are shared,
> but kernel-parameters.txt marked most of them as i386 only.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Yeah this should make things less confusing, applied to linux-next, thanks.

Jesse
